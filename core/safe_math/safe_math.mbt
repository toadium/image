///|
/// # 安全算术与核心证明模块
///
/// 提供溢出安全的整数运算、钳制函数、索引检查、编解码核心算法。
/// 带 `proof_ensure` 的函数附带形式化验证契约（moon prove），
/// 确保 SMT 可机检的数学正确性。
///
/// 证明谓词定义在 `safe_math.mbtp` 中。
///
/// MoonBit 证明系统限制（实验性）：
/// - 契约函数体中不支持：raise、return、let mut、while、.abs()、>>、&
/// - 谓词中不支持：>>、&、=>（用 !P || Q 替代）、match Bool
/// - 含复杂类型（Bytes/Array）的包导致 Why3 翻译失败

///|
/// 65535 覆盖常见图像格式最大尺寸（PNG/TIFF 32-bit、JPEG 65500、BMP 32-bit）。
pub const MAX_IMAGE_DIMENSION : Int32 = 65535

// ============================================================================
// Section: 溢出安全乘法
// ============================================================================

///|
/// 安全乘法：返回 a * b，溢出时返回 None。
/// 用于在分配大数组前检查是否会溢出。
///
/// ✅ 形式化验证：证明后置条件 safe_mul_ok 成立。
pub fn safe_mul(
  a : Int32,
  b : Int32,
) -> Int32? where {
  proof_ensure: result => safe_mul_ok(a, b, result),
} {
  if a <= 0 || b <= 0 {
    Some(0)
  } else {
    let max_int = 2147483647
    if a > max_int / b {
      None
    } else {
      Some(a * b)
    }
  }
}

///|
/// 安全三参数乘法：返回 a * b * c，溢出时返回 None。
/// 常用于计算 w * h * channels 的数组大小。
pub fn safe_mul3(a : Int32, b : Int32, c : Int32) -> Int32? {
  match safe_mul(a, b) {
    Some(ab) =>
      match safe_mul(ab, c) {
        Some(abc) => Some(abc)
        None => None
      }
    None => None
  }
}

///|
/// 判断维度是否在安全范围内（纯函数）。
/// 返回 true 当且仅当 width/height/channels 均为正、
/// 不超过 MAX_IMAGE_DIMENSION、且乘积不溢出 Int32。
pub fn dims_valid_check(w : Int32, h : Int32, c : Int32) -> Bool {
  1 <= w &&
  w <= 65535 &&
  1 <= h &&
  h <= 65535 &&
  1 <= c &&
  w <= 2147483647 / h &&
  w * h <= 2147483647 / c
}

// ============================================================================
// Section: 钳制函数（Clamp）
// ============================================================================

///|
/// 通用整数钳制：将 v 限制在 [lo, hi] 范围内。
/// 谓词 clamp_int_ok 保证结果在 [lo, hi] 范围内。
/// 注意：当前 moon prove 对此函数后置条件求解超时，待优化。
pub fn clamp_int(v : Int32, lo : Int32, hi : Int32) -> Int32 {
  if v < lo {
    lo
  } else if v > hi {
    hi
  } else {
    v
  }
}

///|
/// 像素值钳制：将 value 限制在 [0, 255] 范围内。
///
/// ✅ 形式化验证：证明结果在 [0, 255] 范围内。
pub fn clamp_pixel_value(
  value : Int32,
) -> Int32 where {
  proof_ensure: result => clamp_pixel_ok(value, result),
} {
  if value < 0 {
    0
  } else if value > 255 {
    255
  } else {
    value
  }
}

///|
/// 坐标钳制：将坐标 v 限制在 [0, max_val-1] 范围内。
/// 用于图像像素坐标的边界检查。
/// 谓词 clamp_coord_ok 保证结果在 [0, max_val-1] 范围内（当 max > 0）。
/// 注意：当前 moon prove 对此函数后置条件求解超时，待优化。
pub fn clamp_coord(v : Int32, max_val : Int32) -> Int32 {
  if v < 0 {
    0
  } else if v >= max_val {
    max_val - 1
  } else {
    v
  }
}

///|
/// 字节钳制：将 Int32 值限制在 [0, 255] 并转为 Byte。
/// 等价于 clamp_pixel_value(v).to_byte()，用于像素赋值。
pub fn clamp_byte(v : Int32) -> Byte {
  clamp_pixel_value(v).to_byte()
}

///|
/// 浮点钳制：将 Float 值 v 限制在 [lo, hi] 范围内。
/// 用于 16-bit/float 图像处理的范围约束。
pub fn clamp_float(v : Float, lo : Float, hi : Float) -> Float {
  if v < lo {
    lo
  } else if v > hi {
    hi
  } else {
    v
  }
}

///|
/// 双精度浮点钳制：将 Double 值 v 限制在 [lo, hi] 范围内。
/// 用于高精度图像处理（HDR/频域）的范围约束。
pub fn clamp_double(v : Double, lo : Double, hi : Double) -> Double {
  if v < lo {
    lo
  } else if v > hi {
    hi
  } else {
    v
  }
}

// ============================================================================
// Section: 整数 min/max（替代散布全项目的私有 min_/max_ 函数）
// ============================================================================

///|
/// 整数最大值：返回 a 和 b 中较大的那个。
pub fn int_max(a : Int32, b : Int32) -> Int32 {
  if a > b {
    a
  } else {
    b
  }
}

///|
/// 整数最小值：返回 a 和 b 中较小的那个。
pub fn int_min(a : Int32, b : Int32) -> Int32 {
  if a < b {
    a
  } else {
    b
  }
}

// ============================================================================
// Section: 索引合法性检查
// ============================================================================

///|
/// 安全的一维索引检查：0 <= index < length。
///
/// ✅ 形式化验证：证明结果正确判定索引合法性。
pub fn is_valid_index(
  index : Int32,
  length : Int32,
) -> Bool where {
  proof_ensure: result => valid_index(index, length, result),
} {
  index >= 0 && index < length
}

///|
/// 安全的二维索引检查：0 <= x < width && 0 <= y < height。
///
/// ✅ 形式化验证：证明结果正确判定 2D 索引合法性。
pub fn is_valid_2d_index(
  x : Int32,
  y : Int32,
  width : Int32,
  height : Int32,
) -> Bool where {
  proof_ensure: result => valid_2d_index(x, y, width, height, result),
} {
  x >= 0 && x < width && y >= 0 && y < height
}

// ============================================================================
// Section: 几何/旋转恒等性
// ============================================================================

///|
/// 判断 Rotate90 的连续次数是否为恒等变换。
/// 当 n 是 4 的倍数时，连续旋转 n 次 90° 回到原始状态。
///
/// ✅ 形式化验证：证明结果等价于 n % 4 == 0。
pub fn rotate90_power_is_identity(
  n : Int32,
) -> Bool where {
  proof_ensure: result => rotate90_identity(n, result),
} {
  n % 4 == 0
}

// ============================================================================
// Section: 编解码核心算法
// 注意：以下函数使用位运算/方法调用，当前 moon prove 不支持在
// 契约函数体中使用，因此不带 proof_ensure 契约。
// 仍提供安全范围谓词供未来证明系统扩展时使用。
// ============================================================================

///|
/// PNG Paeth 预测函数。
/// 选择 a、b、c 中最接近预测值 p = a + b - c 的那个。
/// 结果必为 {a, b, c} 之一（PNG 规范保证）。
pub fn paeth_predict(a : Int32, b : Int32, c : Int32) -> Int32 {
  let p = a + b - c
  let pa = (p - a).abs()
  let pb = (p - b).abs()
  let pc = (p - c).abs()
  if pa <= pb && pa <= pc {
    a
  } else if pb <= pc {
    b
  } else {
    c
  }
}

///|
/// QOI 哈希函数：将 RGBA 像素映射到 [0, 63] 的索引。
/// 结果在 [0, 63] 范围内（QOI 规范保证）。
pub fn qoi_hash(r : Int32, g : Int32, b : Int32, a : Int32) -> Int32 {
  (r * 3 + g * 5 + b * 7 + a * 11) % 64
}

///|
/// GIF 3-3-2 量化：将 RGB 像素映射到 256 色调色板索引。
/// 结果在 [0, 255] 范围内。
pub fn quantize_332(r : Int32, g : Int32, b : Int32) -> Int32 {
  let r_level = (r >> 5) & 0x07
  let g_level = (g >> 5) & 0x07
  let b_level = (b >> 6) & 0x03
  r_level * 32 + g_level * 4 + b_level
}

///|
/// 汉明距离：计算两个整数在二进制表示下不同位的数量。
/// 结果 >= 0。
pub fn hamming_distance(a : Int32, b : Int32) -> Int32 {
  let xor_val = a ^ b
  let mut count = 0
  let mut x = xor_val
  while x > 0 {
    count += x & 1
    x = x >> 1
  }
  count
}
