# Changelog


## [1.0.8] - 2024-08-02
### Added
- **`borderRadius`**: Added support for customizing the border radius of the toast.
- **`customTextStyle`**: Added support for customizing the text style (font size, color, etc.) of the toast.
- **`animation`**: Added support for animation effects, including zoom animations for icons.


## [1.0.7] - 2024-08-01
### Added
- **`position`**: Added support for positioning the toast at the top or bottom of the screen .
- **`isRTL`**: Added support for right-to-left text direction .



## [1.0.6] - 2024-07-31
### Added
- **Initial release of ToastPlus package**: Provides a static method `show` for displaying toast messages.
- **`ToastWidget` Class**: Implements toast notifications with customizable message, type, and duration.
- **Toast Types**: Added support for different types of toasts (success, danger, info, warning) with distinct colors and icons.
- **Animations**: Introduced fade-in and fade-out animations for toast notifications using `AnimationController` and `FadeTransition`.

### Fixed
- **Dismiss on Close Button Click**: Ensured the toast widget is properly removed from the overlay after the specified duration.

### Changed
- **Improved Design**: Enhanced the visual design of the toast notifications, including background color and icon adjustments.
