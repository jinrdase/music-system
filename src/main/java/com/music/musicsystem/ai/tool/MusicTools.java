package com.music.musicsystem.ai.tool;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.music.musicsystem.ai.config.AiConstants;
import com.music.musicsystem.common.exception.BusinessException;
import com.music.musicsystem.dto.CreateOrderDTO;
import com.music.musicsystem.dto.RefundDTO;
import com.music.musicsystem.service.AlbumService;
import com.music.musicsystem.service.IBlindBoxService;
import com.music.musicsystem.service.OrderService;
import com.music.musicsystem.service.PaymentService;
import com.music.musicsystem.service.RefundService;
import com.music.musicsystem.service.ShoppingCartService;
import com.music.musicsystem.service.UserAddressService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.model.ToolContext;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.ai.tool.annotation.ToolParam;
import org.springframework.stereotype.Component;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * AI 购物助手的工具集：把现有业务查询能力暴露给大模型。
 * <p>
 * 所有涉及"我的数据"的工具，userId 一律从 ToolContext 取（Controller 注入的当前登录用户），
 * 不作为工具参数暴露给模型，防止越权查询。
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class MusicTools {

    private static final int PAGE_SIZE = 10;

    /**
     * 工具结果序列化用 Jackson 3（Spring Framework 7 自带，原生支持 java.time）：
     * VO 里有 LocalDate/LocalDateTime，Jackson 2 不加 jsr310 模块无法序列化，
     * 且 Boot 4 类路径上也没有 Jackson 2 的 ObjectMapper Bean。
     */
    private static final tools.jackson.databind.ObjectMapper OBJECT_MAPPER =
            tools.jackson.databind.json.JsonMapper.builder().build();

    private final AlbumService albumService;
    private final OrderService orderService;
    private final ShoppingCartService shoppingCartService;
    private final PaymentService paymentService;
    private final RefundService refundService;
    private final IBlindBoxService blindBoxService;
    private final UserAddressService userAddressService;

    @Tool(description = "按关键词搜索在售专辑，返回分页列表（含标题、艺人、价格、库存、销量、商品类型）。无关键词则返回全部在售专辑。")
    public String searchAlbums(
            @ToolParam(description = "搜索关键词，匹配专辑名或艺人名，可为空", required = false) String keyword,
            @ToolParam(description = "页码，从 1 开始，缺省为 1", required = false) Integer page) {
        int current = page == null || page < 1 ? 1 : page;
        return execute(() -> pageResult(albumService.getAlbumList(current, PAGE_SIZE, keyword)));
    }

    @Tool(description = "查询单个专辑的详情，包含专辑介绍和全部歌曲列表（歌名、时长、曲目号、播放量）。需要先通过 searchAlbums 拿到专辑 id。")
    public String getAlbumDetail(
            @ToolParam(description = "专辑 id") Long albumId) {
        return execute(() -> albumService.getAlbumDetail(albumId));
    }

    @Tool(description = "查询当前用户的订单列表（分页，按创建时间倒序），含订单号、商品、金额、状态、支付时间、物流单号等。")
    public String getMyOrders(
            @ToolParam(description = "页码，从 1 开始，缺省为 1", required = false) Integer page,
            ToolContext toolContext) {
        int current = page == null || page < 1 ? 1 : page;
        Long userId = currentUserId(toolContext);
        return execute(() -> pageResult(orderService.getUserOrders(userId, current, PAGE_SIZE)));
    }

    @Tool(description = "查询当前用户某个订单的详情，含订单明细（商品类型：实体专辑/数字专辑）和收货信息。需要订单号 orderNo。")
    public String getOrderDetail(
            @ToolParam(description = "订单号，如 20261103xxxx") String orderNo,
            ToolContext toolContext) {
        Long userId = currentUserId(toolContext);
        return execute(() -> orderService.getOrderDetail(userId, orderNo));
    }

    @Tool(description = "查询当前用户购物车的汇总：条目列表（专辑名、单价、数量、小计、勾选状态、库存是否充足）、总件数、勾选件数、总金额、勾选金额。")
    public String getMyCart(ToolContext toolContext) {
        Long userId = currentUserId(toolContext);
        return execute(() -> shoppingCartService.getCartSummary(userId));
    }

    @Tool(description = "按支付单号查询当前用户某笔支付的结果：支付状态（0 待支付/1 成功/2 失败）、金额、支付时间、支付宝交易号。")
    public String queryPayment(
            @ToolParam(description = "支付单号 paymentNo") String paymentNo,
            ToolContext toolContext) {
        Long userId = currentUserId(toolContext);
        return execute(() -> paymentService.queryPaymentResult(userId, paymentNo));
    }

    @Tool(description = "查询当前用户的退款申请列表（分页），含订单号、退款金额、原因、状态、审核备注、审核时间。")
    public String getMyRefunds(
            @ToolParam(description = "页码，从 1 开始，缺省为 1", required = false) Integer page,
            ToolContext toolContext) {
        int current = page == null || page < 1 ? 1 : page;
        Long userId = currentUserId(toolContext);
        return execute(() -> pageResult(refundService.getMyApplications(userId, current, PAGE_SIZE)));
    }

    @Tool(description = "查询当前在售的盲盒列表（分页），含名称、价格、剩余库存、奖品池描述、上下架状态。")
    public String getBlindBoxes(
            @ToolParam(description = "页码，从 1 开始，缺省为 1", required = false) Integer page) {
        int current = page == null || page < 1 ? 1 : page;
        return execute(() -> pageResult(blindBoxService.getBlindBoxList(current, PAGE_SIZE)));
    }

    @Tool(description = "查询当前用户的盲盒抽取记录（分页，按时间倒序），含奖品名、奖品等级、第几抽、是否保底、抽取时间。")
    public String getMyDrawRecords(
            @ToolParam(description = "页码，从 1 开始，缺省为 1", required = false) Integer page,
            ToolContext toolContext) {
        int current = page == null || page < 1 ? 1 : page;
        Long userId = currentUserId(toolContext);
        return execute(() -> pageResult(blindBoxService.getMyDrawRecords(userId, current, PAGE_SIZE)));
    }

    @Tool(description = "查询当前用户的收货地址列表（含地址 id、收件人、电话、完整地址、是否默认）。下单购买实物专辑前，必须先调用本工具让用户选择收货地址。")
    public String getMyAddresses(ToolContext toolContext) {
        Long userId = currentUserId(toolContext);
        return execute(() -> userAddressService.listUserAddresses(userId));
    }

    @Tool(description = "为当前用户创建购买订单（下单后订单为待支付状态，用户需在 15 分钟内自行去『我的订单』完成支付，超时自动取消）。执行前必须先向用户复述商品、数量、单价、总价和收货地址并获得用户明确同意；一次只下一单，禁止未确认连续下单。")
    public String createOrder(
            @ToolParam(description = "专辑 id，须来自 searchAlbums/getAlbumDetail 的真实结果") Long albumId,
            @ToolParam(description = "购买数量，1~10") Integer quantity,
            @ToolParam(description = "收货地址 id（来自 getMyAddresses）。购买实物专辑必填；数字专辑必须传 null", required = false) Long addressId,
            ToolContext toolContext) {
        Long userId = currentUserId(toolContext);
        if (quantity == null || quantity < 1 || quantity > 10) {
            return toJson(Map.of("error", "购买数量必须在 1~10 之间"));
        }
        CreateOrderDTO dto = new CreateOrderDTO();
        dto.setAlbumId(albumId);
        dto.setQuantity(quantity);
        dto.setAddressId(addressId);
        return execute(() -> {
            com.music.musicsystem.vo.OrderVO vo = orderService.createOrder(userId, dto);
            log.info("AI 代用户下单成功：userId={}, albumId={}, quantity={}, addressId={}, orderNo={}",
                    userId, albumId, quantity, addressId, vo.getOrderNo());
            Map<String, Object> result = new LinkedHashMap<>();
            result.put("success", true);
            result.put("orderNo", vo.getOrderNo());
            result.put("albumTitle", vo.getAlbumTitle());
            result.put("quantity", vo.getQuantity());
            result.put("totalAmount", vo.getTotalAmount());
            result.put("statusText", vo.getStatusText());
            result.put("expireTime", vo.getExpireTime());
            result.put("nextStep", "请在 15 分钟内到『我的订单』完成支付，超时自动取消");
            return result;
        });
    }

    @Tool(description = "为当前用户提交退款申请（退款金额为订单全额，由系统确定，审核由管理员完成）。规则：仅已支付且未确认收货的订单可申请；数字专辑已取阅不可退；盲盒已抽取不可退；已发货实物订单必须提供退货物流公司和单号；同一订单不能重复申请。执行前必须先向用户复述订单号、退款金额和原因并获得明确同意。")
    public String applyRefund(
            @ToolParam(description = "订单号 orderNo（来自 getMyOrders/getOrderDetail）") String orderNo,
            @ToolParam(description = "退款原因，不超过 100 字") String reason,
            @ToolParam(description = "详细说明，可选，不超过 500 字", required = false) String description,
            @ToolParam(description = "退货物流公司（已发货实物订单必填）", required = false) String returnCarrier,
            @ToolParam(description = "退货物流单号（已发货实物订单必填）", required = false) String returnTrackingNo,
            ToolContext toolContext) {
        Long userId = currentUserId(toolContext);
        return execute(() -> {
            Object detail = orderService.getOrderDetail(userId, orderNo);
            Long orderId = ((com.music.musicsystem.vo.OrderVO) detail).getId();
            RefundDTO dto = new RefundDTO();
            dto.setOrderId(orderId);
            dto.setReason(reason);
            dto.setDescription(description);
            dto.setReturnCarrier(returnCarrier);
            dto.setReturnTrackingNo(returnTrackingNo);
            com.music.musicsystem.vo.RefundApplicationVO vo = refundService.apply(userId, dto);
            log.info("AI 代用户提交退款申请成功：userId={}, orderNo={}, applicationId={}", userId, orderNo, vo.getId());
            Map<String, Object> result = new LinkedHashMap<>();
            result.put("success", true);
            result.put("applicationId", vo.getId());
            result.put("orderNo", vo.getOrderNo());
            result.put("refundAmount", vo.getRefundAmount());
            result.put("statusText", "待管理员审核");
            return result;
        });
    }

    private Long currentUserId(ToolContext toolContext) {
        Object userId = toolContext.getContext().get(AiConstants.TOOL_CONTEXT_USER_ID);
        if (userId == null) {
            throw new BusinessException(401, "未登录或会话已过期");
        }
        return ((Number) userId).longValue();
    }

    private String execute(ToolCall call) {
        try {
            Object result = call.run();
            return result instanceof String s ? s : OBJECT_MAPPER.writeValueAsString(result);
        } catch (BusinessException e) {
            return toJson(Map.of("error", e.getMessage()));
        } catch (Exception e) {
            log.warn("AI 工具调用失败", e);
            return toJson(Map.of("error", "查询失败，请稍后重试"));
        }
    }

    private String toJson(Object value) {
        try {
            return OBJECT_MAPPER.writeValueAsString(value);
        } catch (Exception e) {
            return "{\"error\":\"结果序列化失败\"}";
        }
    }

    /**
     * 把 MyBatis-Plus 的 Page 裁剪成 LLM 友好的精简结构（去掉排序/查询条件等冗余字段）。
     */
    private Map<String, Object> pageResult(Page<?> page) {
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("current", page.getCurrent());
        result.put("size", page.getSize());
        result.put("total", page.getTotal());
        result.put("pages", page.getPages());
        result.put("records", page.getRecords());
        return result;
    }

    @FunctionalInterface
    private interface ToolCall {
        Object run() throws Exception;
    }
}
