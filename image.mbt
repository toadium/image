///|
/// # walkzzz/image
///
/// Pure MoonBit image processing library with zero C FFI dependency.
///
/// Supports 18 image formats (PNG/JPEG/BMP/GIF/QOI/TGA/PSD/HDR/PNM/TIFF/ICO/CUR/ICNS/APNG/WebP/AVIF/HEIF/JPEG-XL)
/// and multi-target compilation (native/wasm-gc/js/wasm).
///
/// ## Quick Start
///
/// ```moonbit nocheck
/// import "walkzzz/codec/lib"
/// import "walkzzz/core/types"
///
/// let img = @lib.load_from_bytes_auto(bytes)!
/// let blurred = @lib.gaussian_blur(img, 3.0)
/// ```
///
/// ## Module Structure
///
/// | Module | Description | Import |
/// |--------|-------------|--------|
/// | core | Base types (Image, Image16, ImageF, LoadError) | `walkzzz/core/types` |
/// | codec | Encoding/decoding, color, metadata, barcode | `walkzzz/codec/lib` |
/// | process | Image processing algorithms | `walkzzz/process/filter` |
/// | photography | Computational photography | `walkzzz/photography/photo_enhance` |
/// | vision | Computer vision | `walkzzz/vision/ocr` |
/// | domain | Domain-specific applications | `walkzzz/domain/medical` |
///
pub let version : String = "0.5.0"
