# Double Command To Hyper Space

双击 Left Command 触发 Hyper+Space（即 Control+Option+Shift+Command+Space）。

## 配合 Loop 使用

Hyper+Space 在 [Loop](https://github.com/MrKai77/Loop)（窗口管理工具）中绑定为 Maximize Window。

Loop 在触发快捷键时会显示一个 preview 效果，但由于双击 Command 后手指很快就抬起，导致 preview 只会短暂闪现然后立即消失，体验不佳。

## 解决方案

使用 `hold_down_milliseconds` 配合 `vk_none` 让按键持续一段时间：

- `hold_down_milliseconds: 300` - 按键按下后保持 300ms 再释放
- `vk_none` - 忽略物理按键的 key up 事件，确保 hold_down_milliseconds 能完整生效

这样即使快速双击 Command 并松开，Loop 的 preview 也会持续显示 300ms，提供更好的视觉反馈。
