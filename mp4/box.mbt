/// ============================================================================
/// ISO BMFF (MP4) box 结构解析 — 纯 MoonBit 零依赖实现。
/// ============================================================================

///| 4 字节 ASCII fourcc → String。
fn fourcc(data : Bytes, offset : Int) -> String {
  String::from_array([
    Char::from_int(data[offset].to_int()),
    Char::from_int(data[offset + 1].to_int()),
    Char::from_int(data[offset + 2].to_int()),
    Char::from_int(data[offset + 3].to_int()),
  ])
}

///| u32 大端写回（测试合成用）。
fn write_u32(arr : Array[Byte], v : Int) -> Unit {
  arr.push(((v >> 24) & 0xFF).to_byte())
  arr.push(((v >> 16) & 0xFF).to_byte())
  arr.push(((v >> 8) & 0xFF).to_byte())
  arr.push((v & 0xFF).to_byte())
}

///| 4 字符字符串 → 字节（fourcc 写入）。
fn fourcc_bytes(s : String) -> Array[Byte] {
  let arr : Array[Byte] = []
  for c in s {
    arr.push(c.to_int().to_byte())
  }
  arr
}

///| 解析出的 MP4 box。
pub(all) struct Mp4Box {
  box_type : String
  start : Int
  payload_start : Int
  size : Int
}

///| 判断是否为 container box（payload 内为子 box 序列）。
fn is_container(ty : String) -> Bool {
  ty == "moov" ||
  ty == "trak" ||
  ty == "mdia" ||
  ty == "minf" ||
  ty == "stbl" ||
  ty == "edts" ||
  ty == "mvex"
}

///| 在 [start, end) 范围内**单层遍历** box 序列，对每个 box 调用 f。
fn walk_boxes_one_level(
  data : Bytes,
  start : Int,
  end : Int,
  f : (Mp4Box) -> Unit,
) -> Unit {
  var off = start
  while off + 8 <= end {
    let size = read_u32(data, off)
    let ty = fourcc(data, off + 4)
    let header = if size == 1 { 16 } else { 8 }
    if size < header {
      return // 非法 size，停止遍历
    }
    let total = if size == 1 {
      let large = read_u64(data, off + 8)
      if large.to_int() < header || off + large.to_int() > end {
        return // 截断
      }
      large.to_int()
    } else if size == 0 {
      end - off // size==0：box 延伸到容器末尾
    } else {
      size
    }
    if off + total > end {
      return // 截断
    }
    f({
      box_type: ty,
      start: off,
      payload_start: off + header,
      size: total,
    })
    if size == 0 {
      return
    }
    off = off + total
  }
}

///| 在 [start, end) 单层查找指定类型的第一个 box。
fn find_box(
  data : Bytes,
  start : Int,
  end : Int,
  ty : String,
) -> Mp4Box? {
  let mut result : Mp4Box? = None
  walk_boxes_one_level(data, start, end, fn(b) {
    if b.box_type == ty {
      match result {
        None => result = Some(b)
        Some(_) => ()
      }
    }
  })
  result
}

///| 在 [start, end) 单层收集指定类型的全部 box（如多 trak）。
fn collect_boxes(
  data : Bytes,
  start : Int,
  end : Int,
  ty : String,
) -> Array[Mp4Box] {
  let arr : Array[Mp4Box] = []
  walk_boxes_one_level(data, start, end, fn(b) {
    if b.box_type == ty {
      arr.push(b)
    }
  })
  arr
}

///| 遍历 container box 的 payload（单层子 box）。
fn children_of(data : Bytes, b : Mp4Box) -> (Int, Int) {
  (b.payload_start, b.start + b.size)
}

///| 读取 box payload 的指定偏移处的 u32（相对 payload_start）。
fn payload_u32(data : Bytes, b : Mp4Box, rel : Int) -> Int {
  read_u32(data, b.payload_start + rel)
}

///| 读取 box payload 的指定偏移处的 u64。
fn payload_u64(data : Bytes, b : Mp4Box, rel : Int) -> Int64 {
  read_u64(data, b.payload_start + rel)
}

///| 绝对偏移 u32 读取。
fn payload_u32_at(data : Bytes, base : Int, rel : Int) -> Int {
  read_u32(data, base + rel)
}

///| 绝对偏移 u64 读取。
fn payload_u64_at(data : Bytes, base : Int, rel : Int) -> Int64 {
  read_u64(data, base + rel)
}
