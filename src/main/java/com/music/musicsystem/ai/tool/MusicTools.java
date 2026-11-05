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
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;

import java.time.Duration;
import java.util.LinkedHashMap;
import java.util.List;
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

    /** 待确认下单草案的 Redis 键前缀（确认制两步下单，TTL 10 分钟） */
    private static final String PENDING_ORDER_PREFIX = "ai:pending-order:";

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
    private final StringRedisTemplate redisTemplate;

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

    @Tool(description = "下单第一步：登记用户的购买意向并生成待确认摘要（不实际下单）。albumId 与 albumName 至少传一个：优先传 searchAlbums/getAlbumDetail 拿到的真实 albumId；没有 id 时直接把用户提到的专辑名传给 albumName（系统按名称解析，多张同名专辑会返回候选列表让你请用户选择）。调用成功后把返回的 summary 复述给用户，等待用户明确确认后再调用 confirmOrder。")
    public String prepareOrder(
            @ToolParam(description = "专辑 id（来自 searchAlbums/getAlbumDetail 的真实结果）。没有 id 时传 null 并用 albumName 按名称解析", required = false) Long albumId,
            @ToolParam(description = "专辑名称（albumId 为 null 时按名称解析）", required = false) String albumName,
            @ToolParam(description = "购买数量，1~10") Integer quantity,
            @ToolParam(description = "收货地址 id（来自 getMyAddresses）。购买实物专辑必填；数字专辑必须传 null", required = false) Long addressId,
            ToolContext toolContext) {
        Long userId = currentUserId(toolContext);
        if (quantity == null || quantity < 1 || quantity > 10) {
            return toJson(Map.of("error", "购买数量必须在 1~10 之间"));
        }
        return execute(() -> {
            // 按名称解析：id 缺失时用专辑名模糊搜索；命中多张则返回候选列表请用户选择
            Long resolvedAlbumId = albumId;
            if (resolvedAlbumId == null) {
                if (albumName == null || albumName.isBlank()) {
                    return toJson(Map.of("error", "请提供专辑 id 或专辑名称"));
                }
                var candidates = albumService.getAlbumList(1, 10, albumName.trim()).getRecords();
                if (candidates.isEmpty()) {
                    return toJson(Map.of("error", "没有找到名称包含「" + albumName + "」的在售专辑，请确认名称或换其他关键词"));
                }
                if (candidates.size() > 1) {
                    List<Map<String, Object>> options = new java.util.ArrayList<>();
                    for (var c : candidates) {
                        Map<String, Object> o = new LinkedHashMap<>();
                        o.put("albumId", c.getId());
                        o.put("title", c.getTitle());
                        o.put("artist", c.getArtist());
                        o.put("price", c.getPrice());
                        o.put("stock", c.getStock());
                        options.add(o);
                    }
                    return toJson(Map.of("needChoose", true, "message",
                            "找到 " + candidates.size() + " 张同名/相似专辑，请列出候选让用户选择后再调用本工具",
                            "candidates", options));
                }
                resolvedAlbumId = candidates.get(0).getId();
            }
            // 预校验并生成摘要：专辑存在且在售，实物需地址
            com.music.musicsystem.entity.Album album = albumService.getById(resolvedAlbumId);
            if (album == null) {
                return toJson(Map.of("error", "专辑不存在，请通过 searchAlbums 重新选择"));
            }
            if (album.getStatus() == null || album.getStatus() != 1) {
                return toJson(Map.of("error", "该专辑已下架，请选择其他在售专辑"));
            }
            boolean physical = "PHYSICAL".equalsIgnoreCase(album.getProductType());
            String addressText = "数字专辑，无需收货地址";
            Long resolvedAddressId = addressId;
            if (physical) {
                // 未显式指定地址时自动使用用户默认地址（弱模型传参易缺失，按用户习惯兜底）
                if (resolvedAddressId == null) {
                    var def = userAddressService.getDefaultAddress(userId);
                    if (def == null) {
                        return toJson(Map.of("error", "该用户还没有收货地址，请引导用户先到『收货地址』页添加一个再下单"));
                    }
                    resolvedAddressId = def.getId();
                    addressText = "（未指定，自动使用默认地址）" + (def.getFullAddress() != null ? def.getFullAddress()
                            : def.getProvince() + def.getCity() + def.getDistrict() + def.getDetailAddress());
                } else {
                    var addr = userAddressService.getAddressDetail(userId, resolvedAddressId);
                    addressText = addr.getFullAddress() != null ? addr.getFullAddress()
                            : addr.getProvince() + addr.getCity() + addr.getDistrict() + addr.getDetailAddress()
                            + "（收件人：" + addr.getReceiverName() + "）";
                }
            }
            java.math.BigDecimal total = album.getPrice().multiply(java.math.BigDecimal.valueOf(quantity));
            Map<String, Object> draft = new LinkedHashMap<>();
            draft.put("albumId", resolvedAlbumId);
            draft.put("quantity", quantity);
            draft.put("addressId", resolvedAddressId);
            String summary = "商品：" + album.getTitle() + "；单价：¥" + album.getPrice()
                    + "；数量：" + quantity + "；合计：¥" + total + "；收货：" + addressText;
            draft.put("summary", summary);
            // 同一草案重复登记（弱模型确认后仍可能再调 prepareOrder）：不再覆盖，返回强指令要求直接 confirmOrder
            String oldDraft = redisTemplate.opsForValue().get(PENDING_ORDER_PREFIX + userId);
            if (oldDraft != null && oldDraft.contains("\"albumId\":" + resolvedAlbumId)
                    && oldDraft.contains("\"quantity\":" + quantity)) {
                // 同参数重复登记只发生在用户已再次确认之后（弱模型确认环节反复调 prepareOrder）：
                // 视为用户已确认，服务端直接执行下单，不再依赖模型正确调用 confirmOrder
                Map<String, Object> existing = OBJECT_MAPPER.readValue(oldDraft,
                        OBJECT_MAPPER.getTypeFactory().constructMapType(LinkedHashMap.class, String.class, Object.class));
                return executeDraft(userId, existing);
            }
            // 草案暂存 10 分钟，等待用户确认；确认环节凭此下单，模型无需记忆专辑 id
            redisTemplate.opsForValue().set(PENDING_ORDER_PREFIX + userId,
                    OBJECT_MAPPER.writeValueAsString(draft), Duration.ofMinutes(10));
            Map<String, Object> result = new LinkedHashMap<>(draft);
            result.put("prepared", true);
            result.put("nextStep", "请把 summary 原样复述给用户并请求确认，用户明确同意后调用 confirmOrder");
            return result;
        });
    }

    @Tool(description = "下单第二步：用户对 prepareOrder 的摘要明确同意后调用本工具，正式创建待支付订单（服务端凭已登记的草案下单，无需再传参数）。若用户修改了商品或数量，必须重新调用 prepareOrder。")
    public String confirmOrder(ToolContext toolContext) {
        Long userId = currentUserId(toolContext);
        return execute(() -> {
            String json = redisTemplate.opsForValue().get(PENDING_ORDER_PREFIX + userId);
            if (json == null || json.isBlank()) {
                return toJson(Map.of("error", "没有待确认的订单草案，请先用 prepareOrder 登记用户的购买意向"));
            }
            Map<String, Object> draft = OBJECT_MAPPER.readValue(json,
                    OBJECT_MAPPER.getTypeFactory().constructMapType(LinkedHashMap.class, String.class, Object.class));
            return executeDraft(userId, draft);
        });
    }

    /** 执行已确认的草案：删除草案 → 调用真实下单服务 → 返回带凭据的结果 */
    private Map<String, Object> executeDraft(Long userId, Map<String, Object> draft) throws Exception {
        CreateOrderDTO dto = new CreateOrderDTO();
        dto.setAlbumId(((Number) draft.get("albumId")).longValue());
        dto.setQuantity(((Number) draft.get("quantity")).intValue());
        Object addressId = draft.get("addressId");
        dto.setAddressId(addressId == null ? null : ((Number) addressId).longValue());
        redisTemplate.delete(PENDING_ORDER_PREFIX + userId);
        com.music.musicsystem.vo.OrderVO vo = orderService.createOrder(userId, dto);
        log.info("AI 代用户下单成功（确认制）：userId={}, albumId={}, quantity={}, orderNo={}",
                userId, dto.getAlbumId(), dto.getQuantity(), vo.getOrderNo());
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
