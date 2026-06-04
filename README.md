# 舍得 - 个人/项目财务管理 App

> 舍去繁杂，得享从容。

## 项目简介

"舍得"是一款基于 Flutter 开发的个人/项目财务管理 App，聚焦于**应收/应付款项追踪**、**还款计划管理**、**生活成本记录**和**项目投入统计**，帮助用户清晰掌握资金流向与未来支出计划。

### 核心功能

- **记账记录** - 快速记录应付/应收账单，支持编辑/删除/标记完成
- **首页总览** - 净资产（含还款+生活成本负债）、预算进度、近期还款、生活成本应付、待办账单
- **账单日历** - 月视图 + 时间线，多维度标记（应付🔴/还款🟠/生活成本🟢/应收🟢）
- **舍得管理** - 统一支出入口，生活成本（含固定支出自动继承）+ 还款计划管理
- **预算管理** - 设置本月/下月预算，预算随支出+还款自动扣减
- **项目管理** - 按项目维度追踪投资预算和资金流向，支持归档
- **数据导出** - CSV 格式导出所有交易记录

## 技术栈

| 技术 | 用途 |
|------|------|
| Flutter 3.x + Dart | 跨平台框架 |
| provider (ChangeNotifier) | 状态管理 |
| go_router | 路由管理 |
| Hive | 本地数据库持久化 |
| intl | 国际化/日期格式化 |
| uuid | 唯一 ID 生成 |
| share_plus | 数据导出分享 |
| Material 3 | 设计系统基础 |

## 项目结构

```
lib/
├── main.dart                              # 应用入口（Hive 初始化 + Provider 注册）
├── app.dart                               # MaterialApp 配置（主题 + 路由）
├── config/
│   ├── constants.dart                     # 常量（分类、Box 名称、设置 Key）
│   ├── routes.dart                        # GoRouter 路由配置（14+ 路由）
│   └── theme/
│       ├── shede_theme.dart               # ThemeData（浅色 + 深色）
│       ├── shede_colors.dart              # 颜色系统（浅色 + 深色色值）
│       ├── shede_spacing.dart             # 间距/圆角常量
│       └── neu_context.dart              # Neumorphism 主题适配扩展
├── models/
│   ├── transaction.dart / .g.dart         # 账款模型（Hive typeId 0-3）
│   ├── project.dart / .g.dart            # 项目模型（Hive typeId 4-5）
│   ├── repayment.dart / .g.dart          # 还款计划模型（Hive typeId 6-7）
│   └── living_cost.dart / .g.dart        # 生活成本模型（Hive typeId 8-9）
├── providers/
│   ├── transaction_provider.dart          # 账款 CRUD + 统计 + CSV 导出
│   ├── project_provider.dart              # 项目 CRUD + 归档
│   ├── settings_provider.dart             # 用户设置（主题/预算/提醒）
│   ├── repayment_provider.dart            # 还款计划 CRUD + 自动继承
│   └── living_cost_provider.dart          # 生活成本 CRUD + 固定支出自动填充
├── screens/
│   ├── home/home_screen.dart              # 首页（净资产+预算+还款+生活成本+待办）
│   ├── calendar/calendar_screen.dart      # 日历（月视图+时间线+详情弹窗）
│   ├── add/add_screen.dart                # 记账（自定义键盘+编辑模式）
│   ├── statistics/statistics_screen.dart  # 统计（项目预算+资金流向）
│   ├── expense_manage/                    # 舍得管理（生活成本+还款统一入口）
│   ├── budget/budget_manage_screen.dart   # 预算管理（本月/下月）
│   ├── repayment/                         # 还款计划管理
│   ├── living_cost/                       # 生活成本管理
│   ├── project/                           # 项目管理（列表+详情）
│   ├── settings/                          # 设置（主题/预算/提醒）
│   └── export/export_screen.dart          # 数据导出
└── widgets/
    ├── main_scaffold.dart                 # 悬浮底部导航栏（Neumorphism 胶囊）
    └── neu_date_picker.dart              # 自定义 Neumorphism 日期选择器
```

## 设计系统

### 风格：Neumorphism（新拟态）

| 元素 | 实现 |
|------|------|
| 凸起效果 | 同色背景 + 双向阴影（左上亮 + 右下暗） |
| 凹陷效果 | 反向阴影（选中态、输入框） |
| 圆角 | 8px（小元素）/ 16px（卡片）/ 28px（导航栏） |
| 动效 | 交错渐入、按压缩放、闪烁光标 |

### 色彩系统

| Token | 浅色模式 | 深色模式 | 用途 |
|-------|---------|---------|------|
| background | #E0E5EC | #2D2D35 | 页面背景 |
| label | #2D3748 | #E8E8EC | 主要文字 |
| secondaryLabel | #8E99A4 | #9898A0 | 次要文字 |
| tintColor | #6C8EBF | #8BA8D0 | 强调色/可交互元素 |
| systemGreen | #6BAF7B | #7EC48E | 收入/成功 |
| systemRed | #D4726A | #E88880 | 支出/错误 |
| systemOrange | #D4A55A | #E8C070 | 警告/还款 |

## 开发指南

### 环境要求

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0

### 安装依赖

```bash
flutter pub get
```

### 运行项目

```bash
# 开发模式
flutter run

# Web
flutter run -d chrome

# 构建 APK
flutter build apk
```

### 设计规范

详细的设计规范请参考 [DESIGN_SPEC.md](./DESIGN_SPEC.md)，包含：

- 完整的 Design Token 定义
- 页面结构与组件规范
- 交互行为描述
- Flutter 实现参考代码

## 开发状态

- [x] 项目骨架搭建
- [x] 主题系统配置（Neumorphism + 深色模式）
- [x] 路由系统配置（14+ 路由，iOS 风格转场）
- [x] 数据模型定义（4 模型，10 个 Hive TypeAdapter）
- [x] 本地存储服务（Hive，5 个 Box）
- [x] 状态管理 Provider（5 个 ChangeNotifier）
- [x] 首页完整实现
- [x] 日历页完整实现
- [x] 记账页完整实现（含编辑模式）
- [x] 统计页完整实现
- [x] 设置页完整实现
- [x] 项目管理完整实现
- [x] 还款计划完整实现
- [x] 生活成本完整实现（含固定支出自动继承）
- [x] 预算管理完整实现
- [x] 数据导出（CSV）
- [ ] 单元测试
- [ ] 集成测试
- [ ] 云同步
- [ ] 推送通知

## 许可证

MIT License

---

**舍得** - 舍去繁杂，得享从容。
