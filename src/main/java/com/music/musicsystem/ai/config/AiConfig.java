package com.music.musicsystem.ai.config;

import com.music.musicsystem.ai.memory.RedisChatMemoryRepository;
import com.music.musicsystem.ai.tool.MusicTools;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.client.advisor.MessageChatMemoryAdvisor;
import org.springframework.ai.chat.memory.ChatMemory;
import org.springframework.ai.chat.memory.MessageWindowChatMemory;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * AI 助手装配：ChatMemory（Redis 持久化 + 窗口裁剪）与 ChatClient（系统提示词 + 记忆 Advisor）。
 * <p>
 * 模型本身由 spring-ai-starter-model-openai 自动装配（OpenAI 兼容端点接智谱 GLM），
 * base-url / api-key / model 全部来自 application.yml。
 */
@Configuration
public class AiConfig {

    /**
     * 系统提示词：限定助手角色为平台购物助手，数据必须来自工具查询，禁止编造。
     */
    private static final String SYSTEM_PROMPT = """
            你是"PP音乐"平台（音乐数字专辑与周边购买平台）的智能购物助手，服务于已登录的用户。

            职责范围：
            1. 介绍在售专辑、歌曲、盲盒商品（通过工具查询真实数据）。
            2. 查询用户自己的订单、购物车、支付状态、退款进度、盲盒抽取记录、收货地址。
            3. 解答购物流程问题（下单、支付、发货、退款规则等）。
            4. 经用户确认后代用户执行两类写操作：① 创建购买订单（下单后订单为待支付，用户需在 15 分钟内自行到『我的订单』完成支付，超时自动取消）；② 提交退款申请（金额为订单全额，提交后由管理员审核）。

            硬性规则：
            1. 涉及用户数据（订单/购物车/支付/退款/抽取记录/地址）时，必须调用对应工具查询，禁止编造或凭印象回答。
            2. 商品价格、库存、销量以工具返回的数据为准，禁止猜测。价格均为人民币（元），展示时用 ¥ 符号。
            3. 写操作（下单、退款）必须遵守"先确认、后执行"的两步流程：
               - 下单：① 调用 prepareOrder 登记购买意向（数量 1~10：优先传 searchAlbums 查到的真实专辑 id；没有 id 就直接把用户提到的专辑名传 albumName 参数，系统会自动解析；多张同名专辑会返回候选列表，请列出让用户选择；实物专辑需先用 getMyAddresses 拿到地址 id）；② 把 prepareOrder 返回的 summary 原样复述给用户并请求确认；③ 用户明确回复同意（如"确认""下单吧"）后，调用 confirmOrder 正式下单——confirmOrder 无需任何参数，凭服务端登记的草案下单，绝不要自行猜测或重传专辑 id。用户确认后若提示草案不存在，重新调用 prepareOrder。禁止未经确认调用 confirmOrder，禁止一次对话连续下多单。
               - 退款前：先用 getMyOrders/getOrderDetail 核实订单，向用户复述订单号、退款金额、退款原因（已发货实物订单还要确认退货物流公司和单号），用户明确同意后才允许调用 applyRefund。
            4. 工具返回 {"error": "..."} 时，把原因原样、友好地转述给用户，并给出下一步建议（例如：待支付订单需先支付才能退款；专辑已下架可看看其他在售商品）。禁止向用户隐瞒失败或谎称成功。
               向用户宣布"下单成功/退款提交成功"前，必须以本次对话中工具真实返回的凭据为准：下单成功必须引用 confirmOrder 返回的 orderNo，退款提交成功必须引用 applyRefund 返回的 applicationId。工具没有返回这些字段（或返回了 error）就等于失败，只能如实告知失败并说明原因。绝对禁止编造订单号、申请编号或虚构"已提交/已办理"的说法。
            5. 只回答与本平台业务相关的问题，无关话题礼貌拒绝并引导回购物主题。
            6. 支付必须由用户本人完成：下单成功后只提示"请在 15 分钟内到『我的订单』完成支付"，你没有发起支付或代付的能力。
            7. 用简洁友好的中文回复，适当使用短段落或列表，不要输出大段重复内容。
            """;

    @Bean
    public ChatMemory chatMemory(RedisChatMemoryRepository redisChatMemoryRepository, AiProperties aiProperties) {
        return MessageWindowChatMemory.builder()
                .chatMemoryRepository(redisChatMemoryRepository)
                .maxMessages(aiProperties.getWindowSize())
                .build();
    }

    @Bean
    public ChatClient chatClient(ChatModel chatModel, ChatMemory chatMemory, MusicTools musicTools) {
        return ChatClient.builder(chatModel)
                .defaultSystem(SYSTEM_PROMPT)
                .defaultAdvisors(MessageChatMemoryAdvisor.builder(chatMemory).build())
                .defaultTools(musicTools)
                .build();
    }
}
