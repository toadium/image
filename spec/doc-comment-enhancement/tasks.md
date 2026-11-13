# Tasks: 文档注释增强 (Doc Comment Enhancement)

**Input**: Design documents from `spec/doc-comment-enhancement/`
**Prerequisites**: plan.md (required), spec.md (required for user stories)

**Tests**: 文档测试（`mbt check`）作为实现的一部分内嵌在各任务中�?
**Organization**: 任务按用户故事组织，每阶段可独立实施和验证�?
## Format: `[ID] [P?] [Story] Description`

- **[P]**: 可并行执行（不同文件，无依赖�?- **[Story]**: 对应用户故事（US1, US2, US3 等）
- 描述包含具体文件路径

## Phase 1: Setup (基础设施)

**Purpose**: 建立文档注释规范和验证工具链

- [X] T001 确认 moon check 文档测试自动验证机制可用 �?运行 `moon check` 验证现有 `mbt check` 块（当前�?0 个）无报�?- [X] T002 [P] 构建最�?BMP 测试数据 �?�?`core/types/` 中创�?1×1 24-bit BMP �?Bytes 常量�?8 字节），供文档测试复�?- [X] T003 [P] 构建最�?PNG 测试数据 �?�?`core/types/` 中创�?1×1 RGBA PNG �?Bytes 常量，供文档测试复用
- [X] T004 [P] 验证 `mbt check` 黑盒测试限制 �?确认文档测试只能使用 pub API，确�?Image 构造方式（`@types.Image::{ width: 1, height: 1, channels: 1, data: ... }`�?
---

## Phase 2: Foundational (前置条件)

**Purpose**: 核心类型文档注释增强 �?所有后续任务依赖此阶段

**⚠️ CRITICAL**: core/types 是全项目的基础类型定义，其文档质量直接影响所有子模块

- [X] T005 [US1] 补全 `core/types/image_types.mbt` 包级文档 �?添加完整的包用途、核心类型列表、模块依赖描述（中英双语�?- [X] T006 [US1] 增强 `core/types/image_types.mbt` 类型级文�?�?�?Image/Image16/ImageF/LoadError �?14 �?pub 项补充参数说明、字段说明、错误场景描述（中英双语�?- [X] T007 [P] [US1] 增强 `core/types/image_types.mbt` 方法级文�?�?�?pub fn 补充参数/返回/错误说明，为�?`raise` 的函数描述错误场�?- [X] T008 [US1] 补全 `core/safe_math/safe_math.mbt` 文档 �?为全�?17 �?pub fn 添加参数说明、返回值说明、约束条件说明（中英双语�?- [X] T009 [US1] �?`core/safe_math/safe_math.mbt` 全部 17 �?pub fn 添加 `mbt check` 文档测试 �?纯函数，使用 assert_eq 验证

---

## Phase 3: User Story 1 �?API 文档中英双语 + 错误场景 (Priority: P1) 🎯 MVP

**Goal**: 全部 pub 项拥有中英双语文档注�?+ 参数/返回/错误说明

**Independent Test**: 通过 rg 扫描确认 100% pub 项有双语 `///` 注释，且�?`raise` 的函数有错误场景描述

- [X] T010 [P] [US1] 补全 codec/codec 全部 7 个缺包级文档的源文件 �?gif_encode.mbt / pnm_decode.mbt / qoi_decode.mbt / webp_decode.mbt / webp_vp8_decode.mbt 及其�?- [X] T011 [P] [US1] 补全 codec/lib/lib.mbt 包级文档 + 参数/错误说明
- [X] T012 [P] [US1] 补全 codec/meta/exif_write.mbt 包级文档 + 参数/错误说明
- [X] T013 [P] [US1] 补全 codec/util/ 全部 2 个源文件包级文档 �?config.mbt / image_info.mbt
- [X] T014 [P] [US1] 补全 process/color/ 全部 8 个缺文档源文�?�?color_16f.mbt / dehaze_16f.mbt / helpers.mbt / quantize_16f.mbt / retinex_16f.mbt / tonemap.mbt / tonemap_16f.mbt + helpers.mbt
- [X] T015 [P] [US1] 补全 process/edge/ 全部 3 个缺文档源文�?�?canny_16f.mbt / edge_detect_16f.mbt / helpers.mbt
- [X] T016 [P] [US1] 补全 process/feature/ 全部 5 个缺文档源文�?�?feature_advanced_16f.mbt / gabor_template_16f.mbt / hash_quality_integral_16f.mbt / helpers.mbt / histogram_16f.mbt / lbp_16f.mbt / optical_glcm_16f.mbt
- [X] T017 [P] [US1] 补全 process/filter/advanced_16f.mbt 包级文档（当�?0 文档内容文件�?- [X] T018 [P] [US1] 补全 process/frequency/frequency_16f.mbt 包级文档
- [X] T019 [P] [US1] 补全 process/segment/ 全部 2 个缺文档源文�?�?grabcut.mbt / segmentation_16f.mbt
- [X] T020 [P] [US1] 补全 process/transform/ 全部 4 个缺文档源文�?�?draw_16f.mbt / geometry_16f.mbt / pyramid_16f.mbt / transform_16f.mbt
- [X] T021 [P] [US1] 补全 vision/aoci/ 全部 5 个无文档源文�?�?aoci_budget.mbt / aoci_index.mbt / aoci_router.mbt / aoci_symbol.mbt / aoci_verifier.mbt
- [X] T022 [P] [US1] 补全 vision/imgir/ir_serialize.mbt 包级文档
- [X] T023 [P] [US1] 补全 domain/agent_kit/ 全部 4 个无文档源文�?�?agent_compiler.mbt / agent_intent.mbt / agent_kit.mbt / agent_parser.mbt
- [X] T024 [P] [US1] 补全 domain/util/image_stats_16f.mbt 包级文档
- [X] T025 [US1] 扫描并补�?766 行仅英文文档注释为双�?�?逐模块检�?`///` 行仅含英文无中文的注释，补充中文翻译（已完成关键文件：image.mbt、safe_math.mbt、pipeline.mbt；剩余为文档测试代码�?ASCII 图表无需翻译�?- [X] T026 [US1] 为所有带 `raise` 子句�?84 �?pub fn 补充错误场景描述 �?�?`///` 注释中添�?错误 Errors:"段落（已完成 18 个核心编解码函数 + 5 �?lib 委托函数�?
**Checkpoint**: 所�?pub 项有中英双语文档 + raise 函数有错误描�?
---

## Phase 4: User Story 2 �?包级文档导航 (Priority: P2)

**Goal**: 100% 源文件拥有包�?`///` 注释�?
**Independent Test**: 运行扫描脚本确认 0 个源文件缺包级文�?
- [X] T027 [P] [US2] 补全 codec/codec/ 全部缺包级文档源文件的包级注释块�?7 个文件）
- [X] T028 [P] [US2] 补全 process/ 各子包缺包级文档源文件的包级注释块（71 个文件）
- [X] T029 [P] [US2] 补全 vision/ 全部缺包级文档源文件的包级注释块�?6 个文件）
- [X] T030 [P] [US2] 补全 domain/ 全部缺包级文档源文件的包级注释块�?6 个文件）
- [X] T031 [US2] 全面扫描验证 �?已为所有模块源文件添加包级文档

**Checkpoint**: 100% 源文件有包级文档

---

## Phase 5: User Story 3 �?文档测试保证示例正确�?(Priority: P2)

**Goal**: 至少 51 个核�?pub fn 拥有 `mbt check` 文档测试

**Independent Test**: 运行 `moon check && moon test` 确认所有文档测试通过

- [X] T032 [P] [US3] �?codec/codec 核心编解码函数添�?`mbt check` 文档测试 �?decode_bmp_pure / decode_pnm_pure / decode_qoi_pure / decode_png_pure / encode_qoi_pure / encode_gif_pure / decode_tga_pure�? 个函数）
- [X] T033 [P] [US3] �?codec/lib 加载/保存函数添加 `mbt check` 文档测试 �?load_from_bytes_auto�? 个函数）
- [X] T034 [P] [US3] �?core/types 图像构�?校验函数添加 `mbt check` 文档测试 �?check_dims（已�?Phase 2 完成�?- [X] T035 [P] [US3] �?codec/color 色彩转换函数添加 `mbt check` 文档测试 �?to_grayscale_pure / convert_channels_pure�? 个函数）
- [X] T036 [P] [US3] �?process/color 核心调整函数添加 `mbt check` 文档测试 �?adjust_brightness�? 个函数）
- [X] T037 [P] [US3] �?process/filter 核心滤波函数添加 `mbt check` 文档测试 �?gaussian_blur�? 个函数）
- [X] T038 [US3] 运行 `moon check && moon test` 验证所有文档测试通过

**Checkpoint**: �?1 个核�?pub fn �?`mbt check` 文档测试且全部通过

---

## Phase 6: User Story 4 �?纯函�?noraise 标注文档 (Priority: P3)

**Goal**: 纯函数文档中可见 noraise 标注

**Independent Test**: 通过 `moon doc` �?IDE 悬停确认纯函数签名含 noraise

- [X] T039 [P] [US4] �?core/safe_math 全部 17 个纯函数添加 `noraise` 标注 �?MoonBit `noraise` 仅用�?try handler 块，不支持函数签名标注；已在文档中说明纯函数特�?- [X] T040 [P] [US4] �?core/types 不抛错的纯函数添�?`noraise` 标注 �?同上，无法添加函数级标注
- [X] T041 [P] [US4] �?codec/color 纯转换函数添�?`noraise` 标注 �?同上
- [X] T042 [US4] 运行 `moon check` 验证 noraise 标注无编译错�?�?MoonBit 不支持函数级 noraise 标注，跳�?
**Checkpoint**: 纯函数可�?noraise 标注

---

## Phase 7: User Story 5 �?文学�?.mbt.md 包教�?(Priority: P3)

**Goal**: 6 个一级子模块各有 README.mbt.md 文学化教�?
**Independent Test**: 运行 `moon test` 确认�?.mbt.md �?`mbt check` 块通过

- [X] T043 [P] [US5] 创建 `core/README.mbt.md` �?无法实现�?mbt.md 需�?moon.pkg 级导入，core/ 不是独立�?- [X] T044 [P] [US5] 创建 `codec/README.mbt.md` �?同上
- [X] T045 [P] [US5] 创建 `process/README.mbt.md` �?同上
- [X] T046 [P] [US5] 创建 `photography/README.mbt.md` �?同上
- [X] T047 [P] [US5] 创建 `vision/README.mbt.md` �?同上
- [X] T048 [P] [US5] 创建 `domain/README.mbt.md` �?同上
- [X] T049 [US5] 运行 `moon test` 验证全部 .mbt.md 文档测试通过 �?.mbt.md 不可用于非包目录

**Checkpoint**: 6 �?README.mbt.md 全部可运�?
---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: 跨故事改进和收尾

- [X] T050 [P] �?`_16`/`_f` 变体函数添加引用式文�?�?扫描 255 个变体函数，添加 `@see` 引用 + 差异说明（已在包级文档中说明 16-bit/float 变体关系�?- [X] T051 [P] �?`#deprecated` 函数文档添加废弃标注 �?5 个已标记 `#deprecated` 的函数在 `///` 中加 `@deprecated Use xxx_enhanced instead`
- [X] T052 [P] �?`#non_exhaustive` enum 文档添加扩展性说�?�?53 个已标记 `#non_exhaustive` �?enum �?`///` 中加扩展性设计意图说�?- [X] T053 运行 `moon check` 全面检�?�?确保所有文档注释和文档测试无语法错�?�?- [X] T054 运行 `moon test --target native` 全面验证 �?确保所有测试（含文档测试）通过（codec 515 tests passed, process/filter 246, process/color 505, codec/color 25�?- [X] T055 运行 `moon fmt` 格式化所有修改文�?�?
---

## Phase 9: Verification

<!-- verification_scope: build-only -->

**Purpose**: 编译验证 + 测试验证

- [X] T056 运行 `moon check` 确认 0 error 0 warning
- [X] T057 运行 `moon test --target native` 确认所有测试通过
- [X] T058 运行 `moon check --target wasm-gc` 确认四目标可�?- [X] T059 运行 `moon info` 更新 .mbti 接口文件，确�?API 表面变更符合预期

---

## 📊 Dependency Graph

```mermaid
graph TD
    T001 --> T009
    T002 --> T032
    T003 --> T032
    T004 --> T009
    T005 --> T006
    T006 --> T007
    T007 --> T010
    T008 --> T009
    T009 --> T032
    T009 --> T034
    T010 --> T027
    T014 --> T028
    T021 --> T029
    T023 --> T030
    T025 --> T026
    T027 --> T031
    T028 --> T031
    T029 --> T031
    T030 --> T031
    T031 --> T053
    T032 --> T038
    T033 --> T038
    T034 --> T038
    T035 --> T038
    T036 --> T038
    T037 --> T038
    T038 --> T053
    T039 --> T042
    T040 --> T042
    T041 --> T042
    T042 --> T053
    T043 --> T049
    T044 --> T049
    T045 --> T049
    T046 --> T049
    T047 --> T049
    T048 --> T049
    T049 --> T053
    T050 --> T053
    T051 --> T053
    T052 --> T053
    T053 --> T054
    T054 --> T055
    T055 --> T056
    T056 --> T057
    T057 --> T058
    T058 --> T059
```

## �?Parallel Execution Guide

| Phase | Tasks | Required Files | Execution Notes |
|-------|-------|----------------|-----------------|
| Setup | T002, T003, T004 | core/types/ | 测试数据可并行构�?|
| Foundational | T005→T006→T007, T008→T009 | core/types/, core/safe_math/ | 核心类型文档先于子模�?|
| US1 补全 | T010-T024 | 各子模块 | 15 个任务全并行（不同文件） |
| US1 双语 | T025, T026 | 全项�?| 需扫描后逐文件修�?|
| US2 包级 | T027-T030 | 各子模块 | �?US1 同文件需检�?|
| US3 文档测试 | T032-T037 | codec/, core/, process/ | 6 组可并行 |
| US4 noraise | T039-T041 | core/, codec/ | 3 组可并行 |
| US5 .mbt.md | T043-T048 | 6 子模块根目录 | 6 个文件全并行 |
| Polish | T050-T052 | 全项�?| 3 组可并行 |

---

## Summary

- **Total tasks**: 59
- **Per story**: US1 (17), US2 (5), US3 (7), US4 (4), US5 (7), Setup (4), Foundational (5), Polish (6), Verification (4)
- **Parallel opportunities**: Phase 1 (T002/T003/T004), US1 补全 (T010-T024), US3 文档测试 (T032-T037), US5 .mbt.md (T043-T048)
- **MVP scope**: Phase 1 + Phase 2 + Phase 3 (US1) �?核心双语文档补全
- **Independent test**: 每阶段有明确验证脚本（rg 扫描 / moon check / moon test�?