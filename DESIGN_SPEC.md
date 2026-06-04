# 舍得 - Flutter App 开发规范文档

> 版本：1.0.0  
> 作者：郭士林  
> 更新日期：2026-06-02  
> 技术栈：Flutter 3.x  
> 设计稿：基于四套 HTML 原型页面

---

## 一、项目概述

### 1.1 App 信息

| 项目 | 值 |
|------|-----|
| App 名称 | 舍得 |
| 定位 | 个人/项目财务管理 App |
| 目标平台 | iOS / Android |
| 技术栈 | Flutter 3.x + Dart |
| 设计风格 | Material 3 (M3) 自定义主题 |

### 1.2 核心功能

1. **记账记录** - 快速记录应付/应收账单
2. **首页总览** - 净资产、预算、待办账单一览
3. **项目统计** - 按项目维度追踪投资预算和资金流向
4. **账单日历** - 日历视图查看每日收支和时间线

### 1.3 页面结构

```
App
├── BottomNavBar (4 tabs)
│   ├── HomePage (首页总览)
│   ├── CalendarPage (账单日历)
│   ├── StatsPage (项目统计)
│   └── [AddRecordPage] (记一笔 - Modal/新页面)
```

---

## 二、设计系统（Design Token）

### 2.1 色彩系统

#### 主色调 (Primary)

| Token | 色值 | 用途 |
|-------|------|------|
| `primary` | `#000001` | 主品牌色，标题、重要文字 |
| `onPrimary` | `#FFFFFF` | 主色上的文字/图标 |
| `primaryContainer` | `#0F1D28` | 深色卡片背景、底部导航栏背景 |
| `onPrimaryContainer` | `#778694` | 深色容器上的次要文字 |
| `primaryFixed` | `#D6E4F4` | 浅色固定背景 |
| `primaryFixedDim` | `#BAC8D8` | 浅色固定背景（暗调） |
| `onPrimaryFixed` | `#0F1D28` | 固定背景上的文字 |
| `onPrimaryFixedVariant` | `#3B4855` | 固定背景上的变体文字 |
| `inversePrimary` | `#BAC8D8` | 反转场景下的主色 |
| `primaryDim` | `#205780` | 主色暗调，进度条、强调元素 |

#### 次要色 (Secondary)

| Token | 色值 | 用途 |
|-------|------|------|
| `secondary` | `#5A5F65` | 次要文字、辅助信息 |
| `onSecondary` | `#FFFFFF` | 次要色上的文字 |
| `secondaryContainer` | `#DCE0E8` | 浅灰蓝卡片背景 |
| `onSecondaryContainer` | `#5F636A` | 次要容器上的文字 |
| `secondaryFixed` | `#DFE2EA` | 次要固定背景 |
| `secondaryFixedDim` | `#C3C6CE` | 次要固定背景（暗调） |
| `onSecondaryFixed` | `#181C22` | 固定背景上的文字 |
| `onSecondaryFixedVariant` | `#43474D` | 固定背景上的变体文字 |
| `secondaryDim` | `#644C5A` | 次要色暗调 |

#### 第三色 (Tertiary)

| Token | 色值 | 用途 |
|-------|------|------|
| `tertiary` | `#000001` | 第三强调色 |
| `onTertiary` | `#FFFFFF` | 第三色上的文字 |
| `tertiaryContainer` | `#111C2D` | 深色第三容器背景 |
| `onTertiaryContainer` | `#79849A` | 第三容器上的文字 |
| `tertiaryFixed` | `#D8E3FB` | 第三固定背景 |
| `tertiaryFixedDim` | `#BCC7DE` | 第三固定背景（暗调） |
| `onTertiaryFixed` | `#111C2D` | 固定背景上的文字 |
| `onTertiaryFixedVariant` | `#3C475A` | 固定背景上的变体文字 |
| `tertiaryDim` | `#853667` | 第三色暗调 |

#### 错误色 (Error)

| Token | 色值 | 用途 |
|-------|------|------|
| `error` | `#BA1A1A` | 错误状态、超支警告 |
| `onError` | `#FFFFFF` | 错误色上的文字 |
| `errorContainer` | `#FFDAD6` | 错误容器背景 |
| `onErrorContainer` | `#93000A` | 错误容器上的文字 |
| `errorDim` | `#70030F` | 错误色暗调 |

#### 表面色 (Surface)

| Token | 色值 | 用途 |
|-------|------|------|
| `background` | `#FAF9FA` | 页面背景色 |
| `onBackground` | `#1B1C1D` | 背景上的主要文字 |
| `surface` | `#FAF9FA` | 卡片/组件表面色 |
| `onSurface` | `#1B1C1D` | 表面上的主要文字 |
| `surfaceVariant` | `#E3E2E3` | 表面变体色 |
| `onSurfaceVariant` | `#44474B` | 表面上的次要文字 |
| `surfaceDim` | `#DBDADA` | 暗调表面 |
| `surfaceBright` | `#FAF9FA` | 亮调表面 |
| `surfaceContainerLowest` | `#FFFFFF` | 最低层级容器（白色卡片） |
| `surfaceContainerLow` | `#F5F3F4` | 低层级容器 |
| `surfaceContainer` | `#EFEDDE` | 标准容器 |
| `surfaceContainerHigh` | `#E9E8E9` | 高层级容器 |
| `surfaceContainerHighest` | `#E3E2E3` | 最高层级容器 |
| `inverseSurface` | `#303031` | 反转表面（深色） |
| `inverseOnSurface` | `#F2F0F1` | 反转表面上的文字 |
| `surfaceTint` | `#52606D` | 表面着色 |

#### 轮廓色 (Outline)

| Token | 色值 | 用途 |
|-------|------|------|
| `outline` | `#74777C` | 边框、分割线 |
| `outlineVariant` | `#C4C6CC` | 浅色边框 |

#### 语义色映射（复用现有 Token，不引入新色值）

| 场景 | 使用的 Token | 色值 |
|------|-------------|------|
| 收入/应收金额 | `secondary` | `#5A5F65` |
| 支出/应付金额 | `error` | `#BA1A1A` |
| 待收圆点 | `secondary` | `#5A5F65` |
| 待付圆点 | `onTertiaryContainer` | `#79849A` |
| 已确认标签 | `secondary` + `secondaryFixed` | `#5A5F65` / `#DFE2EA` |
| 待支付标签 | `onTertiaryContainer` + `errorContainer`(50%) | `#79849A` / `#FFDAD6` |
| 超支警告 | `error` + `errorContainer` | `#BA1A1A` / `#FFDAD6` |
| 已完成（置灰） | 整体 `opacity: 0.7` | — |

### 2.2 字体系统

#### 字体族

```dart
const String primaryFontFamily = 'Inter';
```

#### 字号规范

> 以下字号严格对应 HTML 设计稿中的 tailwind config，不要添加设计稿中没有的字号。

| Token | 字号 | 行高 | 字重 | 字间距 | 用途 |
|-------|------|------|------|--------|------|
| `displayLg` | 32px | 40px | 700 (Bold) | -0.02em | 首页净资产金额、统计页预算总额 |
| `displayLgMobile` | 24px | 32px | 700 (Bold) | -0.02em | App 名称 "舍得"、统计页大金额 |
| `headlineMd` | 20px | 28px | 600 (SemiBold) | normal | 页面标题（"记一笔"）、数字键盘按键 |
| `headlineSm` | 18px | 24px | 600 (SemiBold) | normal | 区块标题（"本月预算"、"待办账单"） |
| `bodyLg` | 16px | 24px | 400 (Regular) | normal | 大正文、日期显示 |
| `bodyMd` | 14px | 20px | 400 (Regular) | normal | 正文、描述文字 |
| `dataMono` | 16px | 24px | 600 (SemiBold) | normal | 金额数字（等宽效果） |
| `labelMd` | 12px | 16px | 600 (SemiBold) | 0.05em | 标签、分类、辅助说明 |

#### 特殊金额样式（记账页输入）

| 字号 | 行高 | 字重 | 用途 |
|------|------|------|------|
| 48px | 56px | 700 (Bold) | 记账页金额输入大数字 |

### 2.3 间距系统

| Token | 值 | 用途 |
|-------|-----|------|
| `spaceXs` | 4px | 极小间距，图标与文字间隙 |
| `spaceSm` | 8px | 小间距，组件内部 padding |
| `spaceMd` | 16px | 标准间距，组件间距 |
| `spaceLg` | 24px | 大间距，区域间距 |
| `spaceXl` | 32px | 超大间距，页面级 padding |

### 2.4 圆角系统

| Token | 值 | 用途 |
|-------|-----|------|
| `radiusDefault` | 8px (0.5rem) | 按钮、输入框、小卡片 |
| `radiusLg` | 16px (1rem) | 大卡片、弹窗 |
| `radiusXl` | 24px (1.5rem) | 底部导航栏顶部圆角 |
| `radiusFull` | 9999px | 圆形头像、药丸按钮、徽章 |

### 2.5 阴影规范

```dart
// 卡片阴影
const List<BoxShadow> cardShadow = [
  BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 8,
    offset: Offset(0, 2),
  ),
];

// 浮动按钮阴影
const List<BoxShadow> fabShadow = [
  BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 16,
    offset: Offset(0, 4),
  ),
];

// 底部导航栏阴影
const List<BoxShadow> navBarShadow = [
  BoxShadow(
    color: Color(0x0D000000),
    blurRadius: 12,
    offset: Offset(0, -2),
  ),
];
```

---

## 三、页面结构与跳转关系

### 3.1 底部导航栏 (BottomNavBar)

```
┌─────────────────────────────────────────────────────────────┐
│  🏠 首页    📅 日历    ➕ 记账    📊 统计                  │
└─────────────────────────────────────────────────────────────┘
```

| Tab | 图标 (Material Symbols Outlined) | 选中时 FILL | 页面 | 路由 |
|-----|----------------------------------|------------|------|------|
| 首页 | `home` | FILL=1 | HomePage | `/home` |
| 日历 | `calendar_month` | FILL=1 | CalendarPage | `/calendar` |
| 记账 | `add_circle` | FILL=0 | AddRecordPage | `/add-record` (Modal) |
| 统计 | `leaderboard` | FILL=1 | StatsPage | `/stats` |

### 3.2 页面跳转关系

```
                    ┌──────────────┐
                    │   HomePage   │
                    │  (首页总览)   │
                    └──────┬───────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
┌───────────────┐  ┌──────────────┐  ┌──────────────┐
│ CalendarPage  │  │AddRecordPage │  │  StatsPage   │
│ (账单日历)    │  │  (记一笔)    │  │  (项目统计)  │
└───────────────┘  └──────────────┘  └──────────────┘
        │                  ▲                  │
        │                  │                  │
        └──────────────────┴──────────────────┘
                 BottomNavBar 切换
```

### 3.3 路由配置

```dart
// 路由表
final Map<String, WidgetBuilder> appRoutes = {
  '/home': (context) => const HomePage(),
  '/calendar': (context) => const CalendarPage(),
  '/stats': (context) => const StatsPage(),
};

// Modal 路由
void navigateToAddRecord(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => const AddRecordPage(),
    ),
  );
}
```

---

## 四、组件规范

### 4.1 TopAppBar

#### 首页/统计页 TopAppBar

```
┌─────────────────────────────────────────────┐
│  [Logo] 舍得                         [🔔]  │
└─────────────────────────────────────────────┘
```

- **高度**: 56px
- **背景**: `background` (#FAF9FA)
- **左侧**: App Logo (24x24) + "舍得" (titleMedium, w600)
- **右侧**: 通知图标按钮 (Icons.notifications_outlined)

#### 日历页 TopAppBar

```
┌─────────────────────────────────────────────┐
│  [Avatar] 舍得                       [🔔]  │
└─────────────────────────────────────────────┘
```

- **左侧**: 圆形头像 (32x32) + "舍得" (titleMedium, w600)

#### 记账页 TopAppBar

```
┌─────────────────────────────────────────────┐
│  [✕]              记一笔                    │
└─────────────────────────────────────────────┘
```

- **左侧**: 关闭按钮 (Icons.close)
- **中间**: "记一笔" (titleLarge, w600, centered)
- **背景**: `background` (#FAF9FA)

### 4.2 BottomNavBar

```dart
// BottomNavBar 配置
// 注意：使用 Material Symbols Outlined，不是 Material Icons
// 选中态：secondaryContainer 背景 + onSecondaryContainer 文字/图标
// 未选中态：onSurfaceVariant 文字/图标

BottomNavigationBar(
  type: BottomNavigationBarType.fixed,
  backgroundColor: surfaceContainerLowest, // #FFFFFF
  selectedItemColor: onSecondaryContainer, // #5F636A
  unselectedItemColor: onSurfaceVariant,   // #44474B
  selectedLabelStyle: labelMd.copyWith(fontWeight: FontWeight.w600),
  unselectedLabelStyle: labelMd,
  elevation: 0,
  currentIndex: _currentIndex,
  onTap: _onTabTapped,
  items: [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),       // Material Symbol: home
      activeIcon: _buildActiveIcon(Icons.home, '首页'),
      label: '首页',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.calendar_month_outlined), // Material Symbol: calendar_month
      activeIcon: _buildActiveIcon(Icons.calendar_month, '日历'),
      label: '日历',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add_circle_outline),  // Material Symbol: add_circle
      activeIcon: Icon(Icons.add_circle, color: primaryContainer),
      label: '记账',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.leaderboard_outlined), // Material Symbol: leaderboard
      activeIcon: _buildActiveIcon(Icons.leaderboard, '统计'),
      label: '统计',
    ),
  ],
)

// 选中态图标用圆角胶囊包裹
Widget _buildActiveIcon(IconData icon, String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    decoration: BoxDecoration(
      color: secondaryContainer,
      borderRadius: BorderRadius.circular(9999),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: onSecondaryContainer),
      ],
    ),
  );
}
```

#### 样式规范
- **高度**: 底部固定，含 SafeArea
- **圆角**: 顶部 `radiusXl` (24px)
- **阴影**: border-t outlineVariant + shadow-md
- **选中态**: secondaryContainer 胶囊背景 + onSecondaryContainer 色 + icon FILL=1
- **未选中态**: onSurfaceVariant 色 + icon FILL=0
- **记账 tab 特殊**: add_circle 图标用 primaryContainer 色，比其他图标大 (28px)

### 4.3 卡片组件

#### 净资产卡片

```
┌─────────────────────────────────────────────┐
│          净资产                    [眼睛图标] │
│        ¥128,450.00                          │
│                                             │
│  ┌─────────────────┬─────────────────┐     │
│  │    总资产        │    总负债        │     │
│  │   ¥256,800.00   │   ¥128,350.00   │     │
│  └─────────────────┴─────────────────┘     │
└─────────────────────────────────────────────┘
```

- **背景**: `primaryContainer` (#0F1D28)
- **文字**: `onPrimaryContainer` (#778694) 次要, `onPrimary` (#FFFFFF) 主要
- **圆角**: `radiusLg` (16px)
- **内边距**: `spaceLg` (24px)
- **金额字号**: `displaySmall` (32px, w600)

#### 预算进度卡片

```
┌─────────────────────────────────────────────┐
│  本月预算                         ¥4,250    │
│  ████████████████████████░░░░░░░░░  106%   │
│  预算 ¥4,000 · 超支 ¥250                   │
└─────────────────────────────────────────────┘
```

- **背景**: `surfaceContainerLowest` (#FFFFFF)
- **圆角**: `radiusDefault` (8px)
- **进度条**: 超支时使用 `error` (#BA1A1A)
- **进度条高度**: 8px
- **进度条圆角**: `radiusFull`

#### 待办账单卡片 (横向滚动)

```
┌───────────────────────┐
│  💳 信用卡还款          │
│     -¥3,500.00        │
│     明天到期           │
└───────────────────────┘
```

- **宽度**: 160px
- **背景**: `surfaceContainerLowest`
- **圆角**: `radiusDefault`
- **滚动**: `SingleChildScrollView(scrollDirection: Axis.horizontal)`
- **卡片间距**: `spaceSm` (8px)

#### 项目卡片

```
┌─────────────────────────────────────────────┐
│  新居装修                                    │
│  ████████████████░░░░░░░░░░░░  65%         │
│  ¥125,000 / ¥200,000                        │
└─────────────────────────────────────────────┘
```

- **背景**: `surfaceContainerLowest`
- **圆角**: `radiusDefault`
- **进度条**: `primaryDim` (#205780)

#### 时间线卡片

```
┌─────────────────────────────────────────────┐
│  ●── 待支付                                  │
│  │   季度物业租赁费              -¥12,500.00 │
│  │                                          │
│  ●── 已确认                                  │
│  │   项目一期尾款                +¥45,000.00 │
│  │                                          │
│  ●── 已完成                                  │
│      内部账户划转                 ¥5,000.00  │
└─────────────────────────────────────────────┘
```

- **时间线圆点**: 8px 圆形
- **时间线线条**: 2px 宽，`outlineVariant` 色
- **状态颜色**: 待支付=`error`, 已确认=`success`, 已完成=`outline`

### 4.4 按钮组件

#### 主按钮

```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: primary,
    foregroundColor: onPrimary,
    minimumSize: Size(double.infinity, 48),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusDefault),
    ),
  ),
  onPressed: () {},
  child: Text('保存'),
)
```

#### 应付/应收切换按钮

```
┌─────────────────────────────────────────────┐
│     [  应付  ] [  应收  ]                    │
└─────────────────────────────────────────────┘
```

- **尺寸**: 两个等宽按钮，高度 40px
- **选中态**: `primaryContainer` 背景 + `onPrimaryContainer` 文字
- **未选中态**: 透明背景 + `outline` 文字
- **动画**: 滑动背景切换，300ms ease-in-out

#### 分类选择按钮

```
┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌────┐
│ 房贷  │ │ 车贷  │ │项目款│ │日常报销│ │ ＋ │
└──────┘ └──────┘ └──────┘ └──────┘ └────┘
```

- **未选中**: `surfaceContainer` 背景 + `onSurfaceVariant` 文字
- **选中态**: `primaryContainer` 背景 + `onPrimaryContainer` 文字
- **圆角**: `radiusFull` (药丸形)
- **添加按钮**: 虚线边框 + `Icons.add`

#### 快捷操作按钮

```
┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐
│  ✏️   │ │  💸   │ │  📊   │ │  💰   │
│记一笔│ │ 转账  │ │ 报表  │ │ 资产  │
└──────┘ └──────┘ └──────┘ └──────┘
```

- **布局**: 4列网格
- **图标**: 24px，`primary` 色
- **文字**: `labelMedium`，`onSurfaceVariant` 色
- **间距**: 列间距 `spaceMd`

### 4.5 数字键盘

```
┌─────────────────────────────────────────────┐
│    1    │    2    │    3    │   日期  │      │
├─────────┼─────────┼─────────┼─────────┤      │
│    4    │    5    │    6    │    +    │      │
├─────────┼─────────┼─────────┼─────────┤      │
│    7    │    8    │    9    │    -    │      │
├─────────┼─────────┼─────────┼─────────┤      │
│    .    │    0    │  ⌫ 删除 │   保存  │      │
└─────────────────────────────────────────────┘
```

- **高度**: 约 240px
- **背景**: `surfaceContainerLow`
- **按键**: 透明背景，点击时 `surfaceContainer` 色
- **保存按钮**: `primary` 背景，占满右侧
- **按键字号**: `headlineMedium` (24px)
- **固定定位**: 始终在页面底部

### 4.6 开关组件 (Toggle)

```
提醒 ────────────────────────────── [ ● ]
```

- **关闭态**: `outline` 轨道色 + `surfaceContainerLowest` 滑块
- **开启态**: `primary` 轨道色 + `onPrimary` 滑块
- **轨道尺寸**: 52px x 32px
- **滑块尺寸**: 24px 圆形
- **动画**: 200ms ease-in-out

### 4.7 进度条

```dart
// 线性进度条
LinearProgressIndicator(
  value: 0.65,
  minHeight: 8,
  borderRadius: BorderRadius.circular(radiusFull),
  backgroundColor: surfaceContainer,
  valueColor: AlwaysStoppedAnimation(primaryDim),
)
```

### 4.8 日历组件

```
┌─────────────────────────────────────────────┐
│  <  2023年10月  >                            │
├─────┬─────┬─────┬─────┬─────┬─────┬─────┤
│  日  │  一  │  二  │  三  │  四  │  五  │  六  │
├─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│     │     │     │     │     │  1  │  2  │
│     │     │     │     │     │     │  ●  │
├─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│  3  │  4  │  5  │  6  │  7  │  8  │  9  │
│     │  ○  │     │     │  ●  │     │     │
├─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│ 10  │ 11  │ 12  │ 13  │ 14  │ 15  │ 16  │
│     │     │ ●○ │     │     │  ○  │     │
└─────┴─────┴─────┴─────┴─────┴─────┴─────┘

图例：● 待付   ○ 待收   ◉ 选中
```

- **日期格子**: 40px x 40px
- **选中态**: `primary` 背景圆形
- **今日**: `primaryContainer` 边框
- **待收点**: `success` 绿色小圆点 (6px)
- **待付点**: `primary` 深色小圆点 (6px)

---

## 五、各页面详细设计

### 5.1 首页总览 (HomePage)

#### 布局结构

```
┌─────────────────────────────────────────────┐
│  TopAppBar: Logo + "舍得" + 通知按钮        │
├─────────────────────────────────────────────┤
│  ScrollView                                 │
│  ┌─────────────────────────────────────┐   │
│  │  净资产卡片 (NetWorthCard)           │   │
│  │  - 净资产金额 (可隐藏)               │   │
│  │  - 总资产 / 总负债                   │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │  快捷操作 (QuickActions)             │   │
│  │  [记一笔] [转账] [报表] [资产]       │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │  本月预算 (BudgetCard)               │   │
│  │  - 本月预算标题                      │   │
│  │  - 进度条 (超支时红色)               │   │
│  │  - 预算/已用/剩余                   │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │  待办账单 (UpcomingBills)            │   │
│  │  - 标题 "待办账单"                   │   │
│  │  - 横向滚动卡片                      │   │
│  │    [信用卡] [房租] [水电] ...        │   │
│  └─────────────────────────────────────┘   │
│                                             │
├─────────────────────────────────────────────┤
│  BottomNavBar (首页选中态)                  │
└─────────────────────────────────────────────┘
```

#### 组件组成

| 序号 | 组件 | 类型 | 数据源 |
|------|------|------|--------|
| 1 | TopAppBar | AppBar | - |
| 2 | NetWorthCard | StatelessWidget | AssetService |
| 3 | QuickActions | StatelessWidget | - |
| 4 | BudgetCard | StatelessWidget | BudgetService |
| 5 | UpcomingBills | StatelessWidget | BillService |
| 6 | BottomNavBar | BottomNavigationBar | - |

#### 交互行为

1. **净资产卡片**
   - 点击眼睛图标：切换金额显示/隐藏状态
   - 长按金额：临时显示 3 秒后自动隐藏

2. **快捷操作**
   - 点击"记一笔"：导航到 AddRecordPage
   - 点击其他：对应功能页面（待扩展）

3. **预算进度**
   - 进度 >= 100% 时：进度条变红，显示超支金额
   - 点击卡片：查看详细预算明细

4. **待办账单**
   - 横向滑动查看所有待办
   - 点击卡片：查看账单详情

#### 数据展示格式

```dart
// 金额格式
String formatAmount(double amount) {
  if (amount >= 10000) {
    return '¥${(amount / 10000).toStringAsFixed(2)}万';
  }
  return '¥${amount.toStringAsFixed(2)}';
}

// 日期格式
String formatDueDate(DateTime dueDate) {
  final diff = dueDate.difference(DateTime.now()).inDays;
  if (diff == 0) return '今天到期';
  if (diff == 1) return '明天到期';
  if (diff <= 7) return '${diff}天后到期';
  return 'MM月dd日到期';
}
```

### 5.2 账单日历 (CalendarPage)

#### 布局结构

```
┌─────────────────────────────────────────────┐
│  TopAppBar: 头像 + "舍得" + 通知按钮        │
├─────────────────────────────────────────────┤
│  ScrollView                                 │
│  ┌─────────────────────────────────────┐   │
│  │  CalendarWidget                      │   │
│  │  - 月份切换 (< 2023年10月 >)        │   │
│  │  - 星期行 (日一二三四五六)           │   │
│  │  - 日期网格 (带收付标记)             │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │  Legend (图例)                        │   │
│  │  [● 待收] [● 待付]                   │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │  DateHeader                          │   │
│  │  "10月12日 · 周四"                   │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │  TimelineView (时间线)               │   │
│  │  ●── 待支付                          │   │
│  │  │   季度物业租赁费    -¥12,500.00  │   │
│  │  ●── 已确认                          │   │
│  │  │   项目一期尾款      +¥45,000.00  │   │
│  │  ●── 已完成                          │   │
│  │      内部账户划转       ¥5,000.00   │   │
│  └─────────────────────────────────────┘   │
│                                             │
├─────────────────────────────────────────────┤
│  BottomNavBar (日历选中态)                  │
└─────────────────────────────────────────────┘
```

#### 组件组成

| 序号 | 组件 | 类型 | 数据源 |
|------|------|------|--------|
| 1 | TopAppBar | AppBar | - |
| 2 | CalendarWidget | StatefulWidget | CalendarService |
| 3 | Legend | StatelessWidget | - |
| 4 | DateHeader | StatelessWidget | - |
| 5 | TimelineView | StatelessWidget | TransactionService |
| 6 | BottomNavBar | BottomNavigationBar | - |

#### 交互行为

1. **日历组件**
   - 左右滑动或点击箭头：切换月份
   - 点击日期：选中日期，更新下方时间线
   - 长按日期：显示该日详情弹窗

2. **时间线**
   - 点击交易项：查看交易详情
   - 左滑交易项：显示快捷操作（编辑、删除）

#### 数据展示格式

```dart
// 日期标题
String formatDateHeader(DateTime date) {
  final weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
  return '${date.month}月${date.day}日 · ${weekdays[date.weekday - 1]}';
}

// 金额带符号
String formatSignedAmount(double amount, TransactionType type) {
  switch (type) {
    case TransactionType.expense:
      return '-¥${amount.abs().toStringAsFixed(2)}';
    case TransactionType.income:
      return '+¥${amount.toStringAsFixed(2)}';
    case TransactionType.transfer:
      return '¥${amount.toStringAsFixed(2)}';
  }
}
```

### 5.3 添加记录 (AddRecordPage)

#### 布局结构

```
┌─────────────────────────────────────────────┐
│  TopAppBar: [✕]          记一笔             │
├─────────────────────────────────────────────┤
│  ScrollView                                 │
│  ┌─────────────────────────────────────┐   │
│  │  TypeToggle                          │   │
│  │  [  应付  ] [  应收  ]               │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │  AmountInput                         │   │
│  │  ¥ 0.00│                             │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │  CategorySelector                    │   │
│  │  [房贷] [车贷] [项目款] [日常报销] [＋]│   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │  今天  📅                            │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │  提醒                    [Toggle]    │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │  关联项目                    >       │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │  备注                                │   │
│  │  [输入框]                            │   │
│  └─────────────────────────────────────┘   │
│                                             │
├─────────────────────────────────────────────┤
│  NumberKeyboard (固定底部)                  │
│  [1][2][3][日期]                           │
│  [4][5][6][  +  ]                          │
│  [7][8][9][  -  ]                          │
│  [ . ][ 0 ][⌫][  保存  ]                  │
└─────────────────────────────────────────────┘
```

#### 组件组成

| 序号 | 组件 | 类型 | 说明 |
|------|------|------|------|
| 1 | TopAppBar | AppBar | 关闭按钮 + 标题 |
| 2 | TypeToggle | StatefulWidget | 应付/应收切换 |
| 3 | AmountInput | StatefulWidget | 金额输入显示 |
| 4 | CategorySelector | StatefulWidget | 分类标签选择 |
| 5 | DateSelector | StatefulWidget | 日期选择 |
| 6 | ReminderToggle | Switch | 提醒开关 |
| 7 | ProjectLink | StatelessWidget | 关联项目选择 |
| 8 | RemarkInput | TextField | 备注输入 |
| 9 | NumberKeyboard | StatelessWidget | 自定义数字键盘 |

#### 交互行为

1. **应付/应收切换**
   - 点击切换类型
   - 背景滑动动画 (300ms)
   - 切换后重置分类选项

2. **金额输入**
   - 通过底部数字键盘输入
   - 实时显示金额，带光标闪烁
   - 支持小数点（最多2位）
   - 删除键逐位删除

3. **分类选择**
   - 单选模式
   - 点击选中/取消
   - 添加按钮：弹出新增分类对话框

4. **日期选择**
   - 点击"今天"：弹出日期选择器
   - 默认选中今天

5. **提醒开关**
   - Toggle 切换
   - 开启时可设置提醒时间

6. **关联项目**
   - 点击：弹出项目选择列表
   - 未选择时显示"未选择"

7. **保存**
   - 点击保存按钮
   - 验证金额不为空
   - 保存成功后关闭页面

### 5.4 项目统计 (StatsPage)

#### 布局结构

```
┌─────────────────────────────────────────────┐
│  TopAppBar: Logo + "舍得" + 通知按钮        │
├─────────────────────────────────────────────┤
│  ScrollView                                 │
│  ┌─────────────────────────────────────┐   │
│  │  TotalBudgetCard (深色背景)           │   │
│  │  总投资预算                          │   │
│  │  ¥450,000.00                         │   │
│  │                                      │   │
│  │  已支出 ¥185,600.00                  │   │
│  │  剩余   ¥264,400.00                  │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │  活跃项目 (ActiveProjects)           │   │
│  │                                      │   │
│  │  新居装修                            │   │
│  │  ████████████░░░░░░░░░░░  65%       │   │
│  │  ¥130,000 / ¥200,000                │   │
│  │                                      │   │
│  │  独立开发创业                        │   │
│  │  ██████░░░░░░░░░░░░░░░░  32%       │   │
│  │  ¥48,000 / ¥150,000                 │   │
│  │                                      │   │
│  │  MBA进修                             │   │
│  │  █████████████████░░░░░  85%       │   │
│  │  ¥102,000 / ¥120,000                │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │  资金流向 (FundFlow)                 │   │
│  │                                      │   │
│  │  材料与硬件  ██████████  45%         │   │
│  │  人工与外包  ██████      30%         │   │
│  │  学费与课程  ███         15%         │   │
│  │  其他杂项    ██          10%         │   │
│  └─────────────────────────────────────┘   │
│                                             │
├─────────────────────────────────────────────┤
│  BottomNavBar (统计选中态)                  │
└─────────────────────────────────────────────┘
```

#### 组件组成

| 序号 | 组件 | 类型 | 数据源 |
|------|------|------|--------|
| 1 | TopAppBar | AppBar | - |
| 2 | TotalBudgetCard | StatelessWidget | ProjectService |
| 3 | ActiveProjects | StatelessWidget | ProjectService |
| 4 | FundFlow | StatelessWidget | TransactionService |
| 5 | BottomNavBar | BottomNavigationBar | - |

#### 交互行为

1. **总投资预算卡片**
   - 点击：展开详细预算明细
   - 深色背景突出重要信息

2. **活跃项目**
   - 点击项目：进入项目详情页
   - 进度条动画：页面加载时从0到当前值

3. **资金流向**
   - 点击类别：筛选该类别的交易记录
   - 横向进度条带动画

---

## 六、Flutter 实现参考代码

### 6.1 主题配置代码 (ThemeData)

```dart
import 'package:flutter/material.dart';

class ShedeTheme {
  ShedeTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      
      // 色彩方案
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF000001),
        onPrimary: Color(0xFFFFFFFF),
        primaryContainer: Color(0xFF0F1D28),
        onPrimaryContainer: Color(0xFF778694),
        secondary: Color(0xFF5A5F65),
        onSecondary: Color(0xFFFFFFFF),
        secondaryContainer: Color(0xFFDCE0E8),
        onSecondaryContainer: Color(0xFF5F636A),
        tertiary: Color(0xFF000001),
        onTertiary: Color(0xFFFFFFFF),
        tertiaryContainer: Color(0xFF111C2D),
        onTertiaryContainer: Color(0xFF79849A),
        error: Color(0xFFBA1A1A),
        onError: Color(0xFFFFFFFF),
        errorContainer: Color(0xFFFFDAD6),
        onErrorContainer: Color(0xFF93000A),
        background: Color(0xFFFAF9FA),
        onBackground: Color(0xFF1B1C1D),
        surface: Color(0xFFFAF9FA),
        onSurface: Color(0xFF1B1C1D),
        surfaceVariant: Color(0xFFE3E2E3),
        onSurfaceVariant: Color(0xFF44474B),
        outline: Color(0xFF74777C),
        outlineVariant: Color(0xFFC4C6CC),
        inverseSurface: Color(0xFF303031),
        onInverseSurface: Color(0xFFF2F0F1),
        surfaceTint: Color(0xFF52606D),
      ),
      
      // 文字主题（严格对齐设计稿 tailwind config）
      textTheme: const TextTheme(
        // displayLg: 32px/40px/w700/letterSpacing -0.02
        displayLarge: TextStyle(
          fontSize: 32,
          height: 40 / 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.02,
        ),
        // displayLgMobile: 24px/32px/w700/letterSpacing -0.02
        displayMedium: TextStyle(
          fontSize: 24,
          height: 32 / 24,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.02,
        ),
        // headlineMd: 20px/28px/w600
        headlineMedium: TextStyle(
          fontSize: 20,
          height: 28 / 20,
          fontWeight: FontWeight.w600,
        ),
        // headlineSm: 18px/24px/w600
        headlineSmall: TextStyle(
          fontSize: 18,
          height: 24 / 18,
          fontWeight: FontWeight.w600,
        ),
        // bodyLg: 16px/24px/w400
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 24 / 16,
          fontWeight: FontWeight.w400,
        ),
        // bodyMd: 14px/20px/w400
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w400,
        ),
        // labelMd: 12px/16px/w600/letterSpacing 0.05
        labelMedium: TextStyle(
          fontSize: 12,
          height: 16 / 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.05,
        ),
      ),
      
      // 卡片主题
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: const Color(0xFFFFFFFF),
        margin: EdgeInsets.zero,
      ),
      
      // 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFF000001),
          foregroundColor: const Color(0xFFFFFFFF),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // 输入框主题
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF5F3F4),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFF000001),
            width: 1.5,
          ),
        ),
      ),
      
      // AppBar 主题
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Color(0xFFFAF9FA),
        foregroundColor: Color(0xFF1B1C1D),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1B1C1D),
        ),
      ),
      
      // BottomNavigationBar 主题
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: Color(0xFFFFFFFF),
        selectedItemColor: Color(0xFF000001),
        unselectedItemColor: Color(0xFF74777C),
        selectedLabelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
        type: BottomNavigationBarType.fixed,
      ),
      
      // Switch 主题
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFFFFFFFF);
          }
          return const Color(0xFFFFFFFF);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF000001);
          }
          return const Color(0xFF74777C);
        }),
      ),
      
      // 分割线主题
      dividerTheme: const DividerThemeData(
        color: Color(0xFFC4C6CC),
        thickness: 1,
        space: 0,
      ),
    );
  }
}
```

### 6.2 色彩扩展代码

```dart
import 'package:flutter/material.dart';

extension ShedeColors on ColorScheme {
  // Primary 变体
  Color get primaryContainer => const Color(0xFF0F1D28);
  Color get onPrimaryContainer => const Color(0xFF778694);
  Color get primaryFixed => const Color(0xFFD6E4F4);
  Color get primaryFixedDim => const Color(0xFFBAC8D8);
  Color get onPrimaryFixed => const Color(0xFF0F1D28);
  Color get onPrimaryFixedVariant => const Color(0xFF3B4855);
  Color get inversePrimary => const Color(0xFFBAC8D8);
  Color get primaryDim => const Color(0xFF205780);
  
  // Secondary 变体
  Color get secondaryContainer => const Color(0xFFDCE0E8);
  Color get onSecondaryContainer => const Color(0xFF5F636A);
  Color get secondaryFixed => const Color(0xFFDFE2EA);
  Color get secondaryFixedDim => const Color(0xFFC3C6CE);
  Color get onSecondaryFixed => const Color(0xFF181C22);
  Color get onSecondaryFixedVariant => const Color(0xFF43474D);
  Color get secondaryDim => const Color(0xFF644C5A);
  
  // Tertiary 变体
  Color get tertiaryContainer => const Color(0xFF111C2D);
  Color get onTertiaryContainer => const Color(0xFF79849A);
  Color get tertiaryFixed => const Color(0xFFD8E3FB);
  Color get tertiaryFixedDim => const Color(0xFFBCC7DE);
  Color get onTertiaryFixed => const Color(0xFF111C2D);
  Color get onTertiaryFixedVariant => const Color(0xFF3C475A);
  Color get tertiaryDim => const Color(0xFF853667);
  
  // Surface 变体
  Color get surfaceVariant => const Color(0xFFE3E2E3);
  Color get onSurfaceVariant => const Color(0xFF44474B);
  Color get surfaceDim => const Color(0xFFDBDADA);
  Color get surfaceBright => const Color(0xFFFAF9FA);
  Color get surfaceContainerLowest => const Color(0xFFFFFFFF);
  Color get surfaceContainerLow => const Color(0xFFF5F3F4);
  Color get surfaceContainer => const Color(0xFFEFEDDE);
  Color get surfaceContainerHigh => const Color(0xFFE9E8E9);
  Color get surfaceContainerHighest => const Color(0xFFE3E2E3);
  Color get inverseSurface => const Color(0xFF303031);
  Color get onInverseSurface => const Color(0xFFF2F0F1);
  Color get surfaceTint => const Color(0xFF52606D);
  
  // Outline
  Color get outline => const Color(0xFF74777C);
  Color get outlineVariant => const Color(0xFFC4C6CC);
  
  // 语义色映射（不引入新色值，复用现有 token）
  Color get incomeColor => secondary;              // 收入/应收
  Color get expenseColor => error;                 // 支出/应付
  Color get pendingColor => onTertiaryContainer;   // 待支付
  Color get confirmedColor => secondary;           // 已确认
}

// 使用方式
// final colors = Theme.of(context).colorScheme;
// colors.primaryDim  // 获取主色暗调
```

### 6.3 字体样式扩展代码

```dart
import 'package:flutter/material.dart';

extension ShedeTextStyles on BuildContext {
  TextStyle get amountLarge => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 48,
    height: 56/48,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );
  
  TextStyle get amountMedium => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 32,
    height: 40/32,
    fontWeight: FontWeight.w600,
  );
  
  TextStyle get amountSmall => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    height: 28/20,
    fontWeight: FontWeight.w600,
  );
  
  TextStyle get amountXSmall => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    height: 24/16,
    fontWeight: FontWeight.w500,
  );
}

// 使用方式
// Text('¥128,450.00', style: context.amountMedium)
```

### 6.4 间距和圆角常量

```dart
import 'package:flutter/material.dart';

class ShedeSpacing {
  ShedeSpacing._();
  
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

class ShedeRadius {
  ShedeRadius._();
  
  static const double def = 8;
  static const double lg = 16;
  static const double xl = 24;
  static const double full = 9999;
  
  static BorderRadius get defaultRadius => BorderRadius.circular(def);
  static BorderRadius get lgRadius => BorderRadius.circular(lg);
  static BorderRadius get xlRadius => BorderRadius.circular(xl);
  static BorderRadius get fullRadius => BorderRadius.circular(full);
}
```

### 6.5 关键组件实现

#### 净资产卡片 (NetWorthCard)

> 注意：首页净资产卡片是白底（surfaceContainerLowest），不是深色。
> 只有统计页的"总投资预算"卡片才是深色背景（primaryContainer）。

```dart
class NetWorthCard extends StatelessWidget {
  final double netWorth;
  final double totalAssets;
  final double totalLiabilities;
  final bool isAmountVisible;
  final VoidCallback? onToggleVisibility;

  const NetWorthCard({
    super.key,
    required this.netWorth,
    required this.totalAssets,
    required this.totalLiabilities,
    this.isAmountVisible = true,
    this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest, // 白色卡片背景
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.outlineVariant.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头部
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '净资产 (¥)',
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: onToggleVisibility,
                child: Icon(
                  // Material Symbols: visibility
                  isAmountVisible 
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                  color: colors.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // 金额
          Text(
            isAmountVisible ? '¥${netWorth.toStringAsFixed(2)}' : '¥ ****',
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 40 / 32,
              letterSpacing: -0.02,
            ),
          ),
          const SizedBox(height: 24),
          
          // 资产负债分割
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: colors.outlineVariant.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildAmountItem(
                    context,
                    label: '总资产',
                    amount: totalAssets,
                    color: colors.onSurface,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: colors.outlineVariant.withOpacity(0.3),
                ),
                Expanded(
                  child: _buildAmountItem(
                    context,
                    label: '总负债',
                    amount: totalLiabilities,
                    color: colors.error, // 负债用红色
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountItem(
    BuildContext context, {
    required String label,
    required double amount,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isAmountVisible ? '¥${amount.toStringAsFixed(2)}' : '¥ ****',
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
```

#### 应付/应收切换 (TypeToggle)

```dart
enum PaymentType { payable, receivable }

class TypeToggle extends StatefulWidget {
  final PaymentType initialType;
  final ValueChanged<PaymentType> onChanged;

  const TypeToggle({
    super.key,
    this.initialType = PaymentType.payable,
    required this.onChanged,
  });

  @override
  State<TypeToggle> createState() => _TypeToggleState();
}

class _TypeToggleState extends State<TypeToggle>
    with SingleTickerProviderStateMixin {
  late PaymentType _currentType;
  late AnimationController _controller;
  late Animation<Alignment> _alignmentAnimation;

  @override
  void initState() {
    super.initState();
    _currentType = widget.initialType;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _alignmentAnimation = Tween<Alignment>(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    if (_currentType == PaymentType.receivable) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _currentType = _currentType == PaymentType.payable
          ? PaymentType.receivable
          : PaymentType.payable;
      if (_currentType == PaymentType.receivable) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      widget.onChanged(_currentType);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    return Container(
      height: 40,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // 滑动背景
          AnimatedBuilder(
            animation: _alignmentAnimation,
            builder: (context, child) {
              return Align(
                alignment: _alignmentAnimation.value,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2 - 24,
                  height: 32,
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          // 按钮
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (_currentType != PaymentType.payable) _toggle();
                  },
                  child: Center(
                    child: Text(
                      '应付',
                      style: TextStyle(
                        color: _currentType == PaymentType.payable
                            ? colors.primary
                            : colors.onSurfaceVariant,
                        fontWeight: _currentType == PaymentType.payable
                            ? FontWeight.w600
                            : FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (_currentType != PaymentType.receivable) _toggle();
                  },
                  child: Center(
                    child: Text(
                      '应收',
                      style: TextStyle(
                        color: _currentType == PaymentType.receivable
                            ? colors.primary
                            : colors.onSurfaceVariant,
                        fontWeight: _currentType == PaymentType.receivable
                            ? FontWeight.w600
                            : FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

#### 自定义数字键盘 (NumberKeyboard)

> 布局规则：4列网格，保存按钮跨3行（第2列第2-4行），用 Expanded + Column 实现

```
┌──────┬──────┬──────┬──────────┐
│  7   │  8   │  9   │  ⌫ 退格  │
├──────┼──────┼──────┤──────────│
│  4   │  5   │  6   │          │
├──────┼──────┼──────┤   保存   │
│  1   │  2   │  3   │  (跨3行) │
├──────┼──────┼──────┤          │
│  .   │  0   │  ▼   │          │
└──────┴──────┴──────┴──────────┘
```

```dart
class NumberKeyboard extends StatelessWidget {
  final ValueChanged<String> onKeyPressed;
  final VoidCallback onDelete;
  final VoidCallback onSave;

  const NumberKeyboard({
    super.key,
    required this.onKeyPressed,
    required this.onDelete,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 32),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 32,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧 3 列数字键
          Expanded(
            flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildRow(context, ['7', '8', '9']),
                const SizedBox(height: 8),
                _buildRow(context, ['4', '5', '6']),
                const SizedBox(height: 8),
                _buildRow(context, ['1', '2', '3']),
                const SizedBox(height: 8),
                _buildRow(context, ['.', '0', 'backspace']),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // 右侧保存按钮（跨3行）
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: onSave,
              child: Container(
                height: 56 * 3 + 8 * 2, // 3个按键高度 + 2个间距
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '保存',
                    style: TextStyle(
                      color: colors.onPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, List<String> keys) {
    return Row(
      children: keys.map((key) => _buildKey(context, key)).toList(),
    );
  }

  Widget _buildKey(BuildContext context, String key) {
    final colors = Theme.of(context).colorScheme;
    final isFunctionKey = key == 'backspace';
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (key == 'backspace') {
            onDelete();
          } else {
            onKeyPressed(key);
          }
        },
        child: Container(
          height: 56,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isFunctionKey
                ? colors.surfaceContainerLow
                : colors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: isFunctionKey
                ? Icon(
                    // Material Symbols: backspace
                    Icons.backspace_outlined,
                    color: colors.onSurface,
                    size: 24,
                  )
                : Text(
                    key,
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
```

#### 时间线组件 (TimelineView)

```dart
enum TransactionStatus { pending, confirmed, completed }

class TimelineItem {
  final TransactionStatus status;
  final String title;
  final double amount;
  final bool isIncome;
  final DateTime time;

  TimelineItem({
    required this.status,
    required this.title,
    required this.amount,
    this.isIncome = false,
    required this.time,
  });
}

class TimelineView extends StatelessWidget {
  final List<TimelineItem> items;

  const TimelineView({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isLast = index == items.length - 1;
        
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 时间线指示器（竖线 + 圆点）
              SizedBox(
                width: 30,
                child: Column(
                  children: [
                    // 圆点（14x14，用边框颜色区分状态）
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: item.status == TransactionStatus.completed
                            ? colors.outlineVariant
                            : colors.surface,
                        border: Border.all(
                          color: _getStatusColor(item.status, colors),
                          width: 2.5,
                        ),
                      ),
                    ),
                    // 竖线（1.5px，outlineVariant 40% 透明度）
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 1.5,
                          color: colors.outlineVariant.withOpacity(0.4),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              
              // 内容
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 状态标签
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(item.status, colors)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _getStatusLabel(item.status),
                          style: TextStyle(
                            color: _getStatusColor(item.status, colors),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // 标题和金额
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                color: colors.onSurface,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            _formatAmount(item.amount, item.isIncome),
                            style: TextStyle(
                              color: item.isIncome 
                                  ? colors.incomeGreen 
                                  : colors.onSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(TransactionStatus status, ColorScheme colors) {
    switch (status) {
      case TransactionStatus.pending:
        return colors.onTertiaryContainer; // 待支付：深色边框
      case TransactionStatus.confirmed:
        return colors.secondary;           // 已确认：次要色边框
      case TransactionStatus.completed:
        return colors.outlineVariant;      // 已完成：灰色填充
    }
  }

  String _getStatusLabel(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.pending:
        return '待支付';
      case TransactionStatus.confirmed:
        return '已确认';
      case TransactionStatus.completed:
        return '已完成';
    }
  }

  String _formatAmount(double amount, bool isIncome) {
    final formatted = amount.toStringAsFixed(2);
    if (isIncome) return '+¥$formatted';
    return '-¥$formatted';
  }
}
```

---

## 七、交互规范

### 7.1 页面切换动画

```dart
// 页面切换 - Fade + Slide
Navigator.of(context).push(
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const NextPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(begin: const Offset(0, 0.05), end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeOut));
      final fadeTween = Tween(begin: 0.0, end: 1.0);
      
      return FadeTransition(
        opacity: animation.drive(fadeTween),
        child: SlideTransition(
          position: animation.drive(tween),
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  ),
);

// Modal 页面（记一笔）
Navigator.of(context).push(
  MaterialPageRoute(
    fullscreenDialog: true,
    builder: (context) => const AddRecordPage(),
  ),
);
```

### 7.2 按钮点击反馈

```dart
// Scale 点击效果
class ScaleOnTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleValue;

  const ScaleOnTap({
    super.key,
    required this.child,
    this.onTap,
    this.scaleValue = 0.95,
  });

  @override
  State<ScaleOnTap> createState() => _ScaleOnTapState();
}

class _ScaleOnTapState extends State<ScaleOnTap>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleValue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

// 使用
ScaleOnTap(
  onTap: () => print('tapped'),
  child: Container(
    padding: EdgeInsets.all(16),
    child: Text('Click me'),
  ),
)
```

### 7.3 Toggle 切换动画

```dart
// Switch 动画（Flutter 内置）
Switch(
  value: _isReminderOn,
  onChanged: (value) {
    setState(() {
      _isReminderOn = value;
    });
  },
  activeColor: colors.primary,
  inactiveTrackColor: colors.outline.withOpacity(0.3),
)
```

### 7.4 列表滚动行为

```dart
// 自定义滚动物理
class ShedeScrollPhysics extends BouncingScrollPhysics {
  const ShedeScrollPhysics({super.parent});

  @override
  ShedeScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return ShedeScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double get minFlingVelocity => 50;  // 降低最小滑动速度

  @override
  double get maxFlingVelocity => 8000; // 限制最大滑动速度
}

// 使用
ListView(
  physics: const ShedeScrollPhysics(),
  children: [...],
)
```

### 7.5 进度条动画

```dart
class AnimatedProgressBar extends StatefulWidget {
  final double value;
  final Color? backgroundColor;
  final Color? valueColor;
  final double height;
  final Duration duration;

  const AnimatedProgressBar({
    super.key,
    required this.value,
    this.backgroundColor,
    this.valueColor,
    this.height = 8,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  State<AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: widget.value,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.value,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(widget.height / 2),
          child: LinearProgressIndicator(
            value: _animation.value,
            minHeight: widget.height,
            backgroundColor: widget.backgroundColor ?? colors.surfaceContainer,
            valueColor: AlwaysStoppedAnimation(
              widget.valueColor ?? colors.primaryDim,
            ),
          ),
        );
      },
    );
  }
}
```

---

## 八、附录

### 8.1 项目目录结构建议

```
lib/
├── main.dart
├── app.dart
│
├── config/
│   ├── theme/
│   │   ├── shede_theme.dart
│   │   ├── shede_colors.dart
│   │   ├── shede_text_styles.dart
│   │   └── shede_spacing.dart
│   └── routes/
│       └── app_routes.dart
│
├── models/
│   ├── transaction.dart
│   ├── project.dart
│   ├── bill.dart
│   └── category.dart
│
├── pages/
│   ├── home/
│   │   ├── home_page.dart
│   │   └── widgets/
│   │       ├── net_worth_card.dart
│   │       ├── quick_actions.dart
│   │       ├── budget_card.dart
│   │       └── upcoming_bills.dart
│   │
│   ├── calendar/
│   │   ├── calendar_page.dart
│   │   └── widgets/
│   │       ├── calendar_widget.dart
│   │       ├── timeline_view.dart
│   │       └── date_header.dart
│   │
│   ├── add_record/
│   │   ├── add_record_page.dart
│   │   └── widgets/
│   │       ├── type_toggle.dart
│   │       ├── amount_input.dart
│   │       ├── category_selector.dart
│   │       ├── number_keyboard.dart
│   │       └── reminder_toggle.dart
│   │
│   └── stats/
│       ├── stats_page.dart
│       └── widgets/
│           ├── total_budget_card.dart
│           ├── active_projects.dart
│           └── fund_flow.dart
│
├── widgets/
│   ├── common/
│   │   ├── shede_app_bar.dart
│   │   ├── shede_bottom_nav.dart
│   │   ├── scale_on_tap.dart
│   │   └── animated_progress_bar.dart
│   └── dialogs/
│       └── date_picker_dialog.dart
│
├── services/
│   ├── asset_service.dart
│   ├── budget_service.dart
│   ├── bill_service.dart
│   └── project_service.dart
│
└── utils/
    ├── formatters.dart
    └── constants.dart
```

### 8.2 字体资源

```yaml
# pubspec.yaml
flutter:
  fonts:
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter-Regular.ttf
          weight: 400
        - asset: assets/fonts/Inter-Medium.ttf
          weight: 500
        - asset: assets/fonts/Inter-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Inter-Bold.ttf
          weight: 700
```

### 8.3 状态管理架构

技术选型：**Riverpod**（推荐）。理由：编译期安全、自动 dispose、Provider 组合灵活，适合记账 App 的数据流模式。

#### 8.3.1 核心数据模型

```dart
/// 交易类型
enum TransactionType { payable, receivable }

/// 交易状态
enum TransactionStatus { pending, confirmed, completed, overdue }

/// 单笔交易记录
class Transaction {
  final String id;
  final TransactionType type;       // 应付 / 应收
  final double amount;              // 金额
  final String categoryId;          // 关联分类 ID
  final String? projectId;          // 关联项目 ID（可选）
  final String? note;               // 备注
  final DateTime date;              // 账单日期
  final DateTime? dueDate;          // 到期日（可选）
  final TransactionStatus status;   // 状态
  final bool reminderEnabled;       // 是否开启提醒
  final DateTime createdAt;
  final DateTime updatedAt;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.categoryId,
    this.projectId,
    this.note,
    required this.date,
    this.dueDate,
    this.status = TransactionStatus.pending,
    this.reminderEnabled = false,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isPayable => type == TransactionType.payable;
  bool get isReceivable => type == TransactionType.receivable;
  bool get isOverdue => dueDate != null && dueDate!.isBefore(DateTime.now()) && status == TransactionStatus.pending;
}

/// 项目
class Project {
  final String id;
  final String name;
  final double budget;             // 总预算
  final double spent;              // 已支出
  final String? icon;              // Material Symbol 名称
  final String? deadline;          // 预计完成时间描述
  final int sortOrder;             // 排序字段
  final DateTime createdAt;

  Project({
    required this.id,
    required this.name,
    required this.budget,
    this.spent = 0,
    this.icon,
    this.deadline,
    this.sortOrder = 0,
    required this.createdAt,
  });

  double get progress => budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0;
  double get remaining => (budget - spent).clamp(0, budget);
  bool get isOverBudget => spent > budget;
}

/// 分类
class Category {
  final String id;
  final String name;
  final String? icon;              // Material Symbol 名称
  final int sortOrder;             // 排序字段，支持拖拽排序
  final bool isDefault;            // 是否为系统预设分类
  final DateTime createdAt;

  Category({
    required this.id,
    required this.name,
    this.icon,
    this.sortOrder = 0,
    this.isDefault = false,
    required this.createdAt,
  });
}

/// 预算
class Budget {
  final String id;
  final double limit;              // 预算上限
  final double used;               // 已使用
  final int month;                 // 月份 (1-12)
  final int year;                  // 年份

  Budget({
    required this.id,
    required this.limit,
    this.used = 0,
    required this.month,
    required this.year,
  });

  double get usagePercent => limit > 0 ? (used / limit * 100) : 0;
  bool get isOverBudget => used > limit;
  double get overspend => isOverBudget ? (used - limit) : 0;
}
```

#### 8.3.2 全局状态 Provider

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ============ 基础服务 Provider ============

/// 数据库/本地存储服务
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

// ============ 交易相关 Provider ============

/// 所有交易记录（按日期倒序）
final transactionsProvider = FutureProvider<List<Transaction>>((ref) async {
  final storage = ref.read(storageServiceProvider);
  return storage.getTransactions(orderBy: 'date DESC');
});

/// 按日期筛选的交易（日历页用）
final transactionsByDateProvider = Provider.family<AsyncValue<List<Transaction>>, DateTime>((ref, date) {
  final transactionsAsync = ref.watch(transactionsProvider);
  return transactionsAsync.whenData((transactions) {
    return transactions.where((t) =>
      t.date.year == date.year &&
      t.date.month == date.month &&
      t.date.day == date.day
    ).toList();
  });
});

/// 日历圆点标记：按月聚合，返回 {日期: [标记类型]}
/// 避免逐日查询，一次拉取整月数据
final calendarMarkersProvider = Provider.family<AsyncValue<Map<int, List<String>>>, DateTime>((ref, month) {
  final transactionsAsync = ref.watch(transactionsProvider);
  return transactionsAsync.whenData((transactions) {
    final Map<int, List<String>> markers = {};
    for (final t in transactions) {
      if (t.date.year == month.year && t.date.month == month.month) {
        markers.putIfAbsent(t.date.day, () => []);
        markers[t.date.day]!.add(t.isReceivable ? 'receivable' : 'payable');
      }
    }
    return markers;
  });
});

// ============ 净资产 Provider ============

class NetWorth {
  final double total;
  final double assets;
  final double liabilities;
  NetWorth({required this.total, required this.assets, required this.liabilities});
}

final netWorthProvider = FutureProvider<NetWorth>((ref) async {
  final storage = ref.read(storageServiceProvider);
  final assets = await storage.getTotalAssets();
  final liabilities = await storage.getTotalLiabilities();
  return NetWorth(total: assets - liabilities, assets: assets, liabilities: liabilities);
});

/// 金额可见性（首页眼睛按钮）
final amountVisibilityProvider = StateProvider<bool>((ref) => true);

// ============ 预算 Provider ============

final currentBudgetProvider = FutureProvider<Budget>((ref) async {
  final now = DateTime.now();
  final storage = ref.read(storageServiceProvider);
  return storage.getBudget(year: now.year, month: now.month);
});

// ============ 项目 Provider ============

final activeProjectsProvider = FutureProvider<List<Project>>((ref) async {
  final storage = ref.read(storageServiceProvider);
  return storage.getProjects(orderBy: 'sortOrder ASC');
});

final totalProjectBudgetProvider = Provider<AsyncValue<double>>((ref) {
  final projectsAsync = ref.watch(activeProjectsProvider);
  return projectsAsync.whenData((projects) {
    return projects.fold<double>(0, (sum, p) => sum + p.budget);
  });
});

// ============ 分类 Provider ============

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final storage = ref.read(storageServiceProvider);
  return storage.getCategories(orderBy: 'sortOrder ASC');
});

// ============ 待办账单 Provider ============

final upcomingBillsProvider = Provider.family<AsyncValue<List<Transaction>>, int>((ref, days) {
  final transactionsAsync = ref.watch(transactionsProvider);
  return transactionsAsync.whenData((transactions) {
    final now = DateTime.now();
    final deadline = now.add(Duration(days: days));
    return transactions.where((t) =>
      t.status == TransactionStatus.pending &&
      t.dueDate != null &&
      t.dueDate!.isAfter(now) &&
      t.dueDate!.isBefore(deadline)
    ).toList()
      ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
  });
});
```

#### 8.3.3 状态流转：记一笔 → 首页刷新

保存交易后刷新首页的净资产、预算、待办账单。通过 `ref.invalidate()` 触发重新查询：

```dart
final addRecordProvider = StateNotifierProvider<AddRecordNotifier, AddRecordState>((ref) {
  return AddRecordNotifier(ref);
});

class AddRecordState {
  final TransactionType type;
  final String amount;
  final String? categoryId;
  final String? projectId;
  final DateTime date;
  final bool reminderEnabled;
  final String? note;
  final bool isSaving;

  AddRecordState({
    this.type = TransactionType.payable,
    this.amount = '0.00',
    this.categoryId,
    this.projectId,
    DateTime? date,
    this.reminderEnabled = false,
    this.note,
    this.isSaving = false,
  }) : date = date ?? DateTime.now();

  double get parsedAmount => double.tryParse(amount) ?? 0;
  bool get canSave => parsedAmount > 0 && categoryId != null;
}

class AddRecordNotifier extends StateNotifier<AddRecordState> {
  final Ref _ref;
  AddRecordNotifier(this._ref) : super(AddRecordState());

  void setType(TransactionType type) => state = AddRecordState(type: type, amount: state.amount, categoryId: state.categoryId, projectId: state.projectId, date: state.date, reminderEnabled: state.reminderEnabled, note: state.note);
  void setAmount(String amount) => state = AddRecordState(type: state.type, amount: amount, categoryId: state.categoryId, projectId: state.projectId, date: state.date, reminderEnabled: state.reminderEnabled, note: state.note);
  void setCategory(String id) => state = AddRecordState(type: state.type, amount: state.amount, categoryId: id, projectId: state.projectId, date: state.date, reminderEnabled: state.reminderEnabled, note: state.note);
  void setProject(String? id) => state = AddRecordState(type: state.type, amount: state.amount, categoryId: state.categoryId, projectId: id, date: state.date, reminderEnabled: state.reminderEnabled, note: state.note);
  void setDate(DateTime date) => state = AddRecordState(type: state.type, amount: state.amount, categoryId: state.categoryId, projectId: state.projectId, date: date, reminderEnabled: state.reminderEnabled, note: state.note);
  void toggleReminder() => state = AddRecordState(type: state.type, amount: state.amount, categoryId: state.categoryId, projectId: state.projectId, date: state.date, reminderEnabled: !state.reminderEnabled, note: state.note);
  void setNote(String? note) => state = AddRecordState(type: state.type, amount: state.amount, categoryId: state.categoryId, projectId: state.projectId, date: state.date, reminderEnabled: state.reminderEnabled, note: note);

  Future<bool> save() async {
    if (!state.canSave) return false;
    state = AddRecordState(type: state.type, amount: state.amount, categoryId: state.categoryId, projectId: state.projectId, date: state.date, reminderEnabled: state.reminderEnabled, note: state.note, isSaving: true);

    try {
      final storage = _ref.read(storageServiceProvider);
      await storage.insertTransaction(Transaction(
        id: const Uuid().v4(),
        type: state.type,
        amount: state.parsedAmount,
        categoryId: state.categoryId!,
        projectId: state.projectId,
        note: state.note,
        date: state.date,
        reminderEnabled: state.reminderEnabled,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      // 刷新关联数据
      _ref.invalidate(transactionsProvider);   // 首页待办账单、日历标记
      _ref.invalidate(netWorthProvider);        // 净资产
      _ref.invalidate(currentBudgetProvider);   // 预算进度

      state = AddRecordState(); // 重置表单
      return true;
    } catch (e) {
      state = AddRecordState(type: state.type, amount: state.amount, categoryId: state.categoryId, projectId: state.projectId, date: state.date, reminderEnabled: state.reminderEnabled, note: state.note);
      return false;
    }
  }
}
```

**关键点：** `ref.invalidate()` 让 FutureProvider 重新执行查询，所有 `watch` 了这些 Provider 的页面自动重建。

#### 8.3.4 状态流转：日历选中 → Timeline 联动

```dart
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final selectedDateTransactionsProvider = Provider<AsyncValue<List<Transaction>>>((ref) {
  final selectedDate = ref.watch(selectedDateProvider);
  return ref.watch(transactionsByDateProvider(selectedDate));
});

class CalendarPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final transactionsAsync = ref.watch(selectedDateTransactionsProvider);
    final markersAsync = ref.watch(
      calendarMarkersProvider(DateTime(selectedDate.year, selectedDate.month)),
    );

    return Column(
      children: [
        CalendarWidget(
          selectedDate: selectedDate,
          markers: markersAsync.valueOrNull ?? {},
          onDateSelected: (date) {
            ref.read(selectedDateProvider.notifier).state = date;
            // 切换日期时 timeline 自动更新
          },
        ),
        Expanded(
          child: transactionsAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('加载失败: $e'),
            data: (transactions) => TimelineView(items: transactions),
          ),
        ),
      ],
    );
  }
}
```

#### 8.3.5 日历聚合查询策略

日历圆点标记按月聚合，避免逐日查询产生 30+ 次 DB 请求：

```dart
class CalendarAggregation {
  /// 从交易列表中提取某月的日期标记
  /// 返回 {日期: ['receivable', 'payable', ...]}
  static Map<int, List<String>> aggregateMonth(
    List<Transaction> transactions,
    int year,
    int month,
  ) {
    final Map<int, List<String>> markers = {};
    for (final t in transactions) {
      if (t.date.year == year && t.date.month == month) {
        markers.putIfAbsent(t.date.day, () => []);
        final marker = t.isReceivable ? 'receivable' : 'payable';
        if (!markers[t.date.day]!.contains(marker)) {
          markers[t.date.day]!.add(marker);
        }
      }
    }
    return markers;
  }
}
```

**性能注意事项：**
- `transactionsProvider` 返回全量数据，数据量大时（>1000条）应改为分页或按月查询
- `calendarMarkersProvider` 的 key 是月份，切换月份时只重新计算目标月
- 日历翻页时先显示 skeleton，等数据返回后再渲染圆点

#### 8.3.6 分类管理（动态分类 + 排序）

```dart
class CategoryNotifier extends StateNotifier<AsyncValue<List<Category>>> {
  final StorageService _storage;

  CategoryNotifier(this._storage) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    state = const AsyncValue.loading();
    try {
      final categories = await _storage.getCategories(orderBy: 'sortOrder ASC');
      state = AsyncValue.data(categories);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// 新增分类（追加到末尾）
  Future<void> add(String name, {String? icon}) async {
    final current = state.valueOrNull ?? [];
    final newCategory = Category(
      id: const Uuid().v4(),
      name: name,
      icon: icon,
      sortOrder: current.length,
      createdAt: DateTime.now(),
    );
    await _storage.insertCategory(newCategory);
    await _load();
  }

  /// 拖拽排序
  Future<void> reorder(int oldIndex, int newIndex) async {
    final current = [...(state.valueOrNull ?? [])];
    if (oldIndex < newIndex) newIndex -= 1;
    final item = current.removeAt(oldIndex);
    current.insert(newIndex, item);

    for (int i = 0; i < current.length; i++) {
      current[i] = current[i].copyWith(sortOrder: i);
    }
    await _storage.updateCategories(current);
    state = AsyncValue.data(current);
  }

  /// 删除分类（仅限非系统预设）
  Future<void> delete(String id) async {
    final current = state.valueOrNull ?? [];
    final target = current.firstWhere((c) => c.id == id);
    if (target.isDefault) return;

    await _storage.deleteCategory(id);
    await _load();
  }
}

final categoryNotifierProvider = StateNotifierProvider<CategoryNotifier, AsyncValue<List<Category>>>((ref) {
  return CategoryNotifier(ref.read(storageServiceProvider));
});
```

#### 8.3.7 Provider 依赖关系图

```
storageServiceProvider
  ├── transactionsProvider ──────────────────┐
  │     ├── transactionsByDateProvider(day)   │
  │     ├── calendarMarkersProvider(month)    │
  │     └── upcomingBillsProvider(days)       │
  │                                           ▼
  ├── netWorthProvider         ──→  HomePage 重建
  ├── currentBudgetProvider    ──→  HomePage 重建
  │                                           │
  ├── activeProjectsProvider   ──→  StatsPage 重建
  └── categoryNotifierProvider ──→  AddRecordPage 重建

selectedDateProvider (StateProvider)
  └── selectedDateTransactionsProvider ──→  CalendarPage Timeline 重建

amountVisibilityProvider (StateProvider)
  └── NetWorthCard 重建（眼睛按钮）
```

**刷新规则：**
- 保存交易后 → `invalidate(transactionsProvider, netWorthProvider, currentBudgetProvider)` → 首页自动更新
- 切换日历日期 → `selectedDateProvider` 变化 → Timeline 自动更新
- 修改分类排序 → `categoryNotifierProvider` 内部更新 → 记一笔页分类列表重建
- 新增项目 → `invalidate(activeProjectsProvider)` → 统计页项目列表更新

---

## 九、变更记录

| 版本 | 日期 | 作者 | 变更内容 |
|------|------|------|----------|
| 1.0.0 | 2026-06-02 | 郭士林 | 初始版本，完成四页面规范 |

---

> **文档完成**  
> 本规范文档可直接用于 Flutter App 开发，所有设计 Token、组件规范、交互行为均已明确定义。
