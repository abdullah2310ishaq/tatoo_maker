## Toast usage map

This file documents where the app shows completion/error feedback to the user.

### Global toast utility
- **Implementation**: `lib/utils/toast.dart` (`AppToast.show`)

### Call sites (AppToast)
- **Result (creation/tattoo)**: `lib/creation/result_screen.dart`
  - **share**: no-image / error-sharing
  - **download**: no-image / saved-to-gallery / error-saving
- **Result (flower)**: `lib/flower/flower_result_screen.dart`
  - **share**: no-image / error-sharing
  - **download**: no-image / saved-to-gallery / error-saving
- **Generation (loading)**: `lib/creation/loading_screen.dart`
  - **network**: no-internet toast
- **History**: `lib/history/history_page.dart`
  - **delete**: deleted success
- **Favorites**: `lib/history/favorites_page.dart`
  - **delete**: deleted success
- **Home shell**: `lib/home_shell.dart`
- **Home page**: `lib/creation/home_page.dart`
- **History tile**: `lib/history/history_tile.dart`
- **Virtual try-on**: `lib/creation/virtual_try_on.dart`
- **Camera preview**: `lib/creation/virtual_try_on/pages/camera_preview_screen.dart`

### Call sites (SnackBar) – should be converted to AppToast
- `lib/creation/explore_detail_screen.dart`

