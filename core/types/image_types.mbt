///|
/// 解码结果值对象，承载图像几何元信息与像素数据（8-bit 无符号像素）
#derive(Eq, @debug.Debug)
pub(all) struct Image {
  width : Int32
  height : Int32
  channels : Int32
  data : Bytes
}

///|
pub extend Image with @debug.Debug::{to_repr}

///|
pub extend Image with Eq::{not_equal, equal}

///|
/// 16-bit 解码结果值对象，像素数据为 16-bit 无符号整数（little-endian，每像素 2 字节）
#derive(Eq, @debug.Debug)
pub(all) struct Image16 {
  width : Int32
  height : Int32
  channels : Int32
  data : Bytes
}

///|
pub extend Image16 with @debug.Debug::{to_repr}

///|
pub extend Image16 with Eq::{not_equal, equal}

///|
/// HDR float 解码结果值对象，像素数据为 32-bit IEEE float（little-endian，每像素 4 字节）
#derive(Eq, @debug.Debug)
pub(all) struct ImageF {
  width : Int32
  height : Int32
  channels : Int32
  data : Bytes
}

///|
pub extend ImageF with @debug.Debug::{to_repr}

///|
pub extend ImageF with Eq::{not_equal, equal}

///|
/// 图像信息查询结果，仅含几何元信息，不加载像素数据
#derive(Eq, @debug.Debug)
pub(all) struct ImageInfo {
  width : Int32
  height : Int32
  channels : Int32
}

///|
pub extend ImageInfo with @debug.Debug::{to_repr}

///|
pub extend ImageInfo with Eq::{not_equal, equal}

///|
/// 动画 GIF 解码结果，包含多帧图像和每帧延迟（毫秒）
#derive(Eq, @debug.Debug)
pub(all) struct GifAnimation {
  frames : Array[Image]
  delays : Array[Int32]
}

///|
pub extend GifAnimation with @debug.Debug::{to_repr}

///|
pub extend GifAnimation with Eq::{not_equal, equal}

///|
/// 加载失败领域错误
pub(all) suberror LoadError {
  FileIO(String)
  UnsupportedFormat(String)
  DecodeFailed(String)
  EncodeFailed(String)
}

///|
/// 图像格式枚举
#derive(Eq, @debug.Debug)
#non_exhaustive
pub(all) enum ImageFormat {
  Png
  Jpeg
  Bmp
  Gif
  Tga
  Psd
  Hdr
  Pnm
  Qoi
  Webp
  Tiff
  Ico
  Cur
  Icns
  Apng
  Avif
  Heif
  JpegXl
  Unknown
}

///|
pub extend ImageFormat with @debug.Debug::{to_repr}

///|
pub extend ImageFormat with Eq::{not_equal, equal}

///|
/// resize 滤波器类型
#derive(Eq, @debug.Debug)
pub(all) enum ResizeFilter {
  Default
  Box
  Triangle
  CubicBSPline
  CatmullROM
  Mitchell
  PointSample
}

///|
pub extend ResizeFilter with @debug.Debug::{to_repr}

///|
pub extend ResizeFilter with Eq::{not_equal, equal}

///|
/// resize 边缘处理模式
#derive(Eq, @debug.Debug)
pub(all) enum ResizeEdge {
  Clamp
  Reflect
  Wrap
  Zero
}

///|
pub extend ResizeEdge with @debug.Debug::{to_repr}

///|
pub extend ResizeEdge with Eq::{not_equal, equal}

///|
/// APNG 动画解码结果
#derive(Eq, @debug.Debug)
pub(all) struct PngAnimation {
  frames : Array[Image]
  delays : Array[Int32] // 毫秒
}

///|
pub extend PngAnimation with @debug.Debug::{to_repr}

///|
pub extend PngAnimation with Eq::{not_equal, equal}

///|
/// 图像维度上限（单边最大像素数）。
/// 防止恶意图像声明超大尺寸导致 OOM 或整数溢出。
/// 65535 覆盖常见图像格式最大尺寸（PNG/TIFF 32-bit、JPEG 65500、BMP 32-bit）。
pub const MAX_IMAGE_DIMENSION : Int32 = 65535

///|
/// 校验图像维度是否在安全范围内。
/// 检查 width/height 为正数且不超过 MAX_IMAGE_DIMENSION，
/// 且 width * height * channels 不超过 Int 最大值（防溢出）。
/// 校验失败时 raise LoadError::DecodeFailed。
pub fn check_dims(
  width : Int32,
  height : Int32,
  channels : Int32,
) -> Unit raise LoadError {
  if width <= 0 || height <= 0 || channels <= 0 {
    raise LoadError::DecodeFailed(
      "图像尺寸无效: width=\{width}, height=\{height}, channels=\{channels}",
    )
  }
  if width > MAX_IMAGE_DIMENSION || height > MAX_IMAGE_DIMENSION {
    raise LoadError::DecodeFailed(
      "图像尺寸超过上限 \{MAX_IMAGE_DIMENSION}: width=\{width}, height=\{height}",
    )
  }
  // 检查 width * height * channels 是否溢出
  // Int 在 wasm/native 为 32 位有符号，最大值 2147483647
  // 先算 width * height，再乘 channels
  let max_int = 2147483647
  if width > max_int / height {
    raise LoadError::DecodeFailed(
      "图像像素总数溢出: \{width} * \{height}",
    )
  }
  let pixel_count = width * height
  if pixel_count > max_int / channels {
    raise LoadError::DecodeFailed(
      "图像数据大小溢出: \{pixel_count} * \{channels}",
    )
  }
}

///|
/// 判断维度是否在安全范围内（纯函数，可用于证明前提）。
/// 返回 true 当且仅当 width/height/channels 均为正、
/// 不超过 MAX_IMAGE_DIMENSION、且乘积不溢出 Int32。
pub let dims_valid_check : (Int32, Int32, Int32) -> Bool = @safe_math.dims_valid_check

///|
/// 安全乘法：返回 a * b，溢出时返回 None。
/// 用于在分配大数组前检查是否会溢出。
/// 实际实现和形式化证明在 core/safe_math 包中。
pub let safe_mul : (Int32, Int32) -> Int32? = @safe_math.safe_mul

///|
/// 安全三参数乘法：返回 a * b * c，溢出时返回 None。
/// 常用于计算 w * h * channels 的数组大小。
/// 实际实现和形式化证明在 core/safe_math 包中。
pub let safe_mul3 : (Int32, Int32, Int32) -> Int32? = @safe_math.safe_mul3

///|
/// 通用整数钳制：将 v 限制在 [lo, hi] 范围内。
/// 实际实现在 core/safe_math 包中。
pub let clamp_int : (Int32, Int32, Int32) -> Int32 = @safe_math.clamp_int

///|
/// 像素值钳制：将 value 限制在 [0, 255] 范围内。
/// 实际实现和形式化证明在 core/safe_math 包中。
pub let clamp_pixel_value : (Int32) -> Int32 = @safe_math.clamp_pixel_value

///|
/// 字节钳制：将 Int32 值限制在 [0, 255] 并转为 Byte。
/// 实际实现在 core/safe_math 包中。
pub let clamp_byte : (Int32) -> Byte = @safe_math.clamp_byte

///|
/// 坐标钳制：将坐标 v 限制在 [0, max_val-1] 范围内。
/// 实际实现在 core/safe_math 包中。
pub let clamp_coord : (Int32, Int32) -> Int32 = @safe_math.clamp_coord

///|
/// 浮点钳制：将 Float 值 v 限制在 [lo, hi] 范围内。
/// 实际实现在 core/safe_math 包中。
pub let clamp_float : (Float, Float, Float) -> Float = @safe_math.clamp_float

///|
/// 双精度浮点钳制：将 Double 值 v 限制在 [lo, hi] 范围内。
/// 实际实现在 core/safe_math 包中。
pub let clamp_double : (Double, Double, Double) -> Double = @safe_math.clamp_double

///|
/// 整数最大值：返回 a 和 b 中较大的那个。
/// 实际实现在 core/safe_math 包中。
pub let int_max : (Int32, Int32) -> Int32 = @safe_math.int_max

///|
/// 整数最小值：返回 a 和 b 中较小的那个。
/// 实际实现在 core/safe_math 包中。
pub let int_min : (Int32, Int32) -> Int32 = @safe_math.int_min
