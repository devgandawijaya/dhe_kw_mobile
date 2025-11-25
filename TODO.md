# ToDo for Attendance API Feature Implementation in HomeView

1. lib/services/api_service.dart
   - Add method postAttendance for POST call to "https://e-absensi.bandungkab.go.id/api/stsAbsenToday"
   - Parameters: pegawai_id, tgl (YYYY-MM-DD), jenis_attedance
   - Use form-url-encoded content type

2. lib/viewmodels/home_viewmodel.dart
   - Add postAttendance method wrapping ApiService call with proper parameters
   - Process API response JSON and handle error cases if any

3. lib/views/home_view.dart
   - Add onTap handlers for "Masuk" and "Pulang" _MenuItem widgets
   - Call viewmodel.postAttendance passing jenis_attedance 1 for masuk, 2 for pulang(?)
   - If API response jammasuk or jampulang is empty/null, navigate to absen_view or pulang_view respectively
   - Else, show bottom dialog "anda sudah absen masuk" or "anda sudah absen pulang"
   - Implement bottom dialog UI possibly with showModalBottomSheet()
   - Use current date in YYYY-MM-DD format

4. Testing
   - Test API call integration and UI flow on successful and repeated attendance cases

Next step: Implement step 1, adding attendance method in ApiService.
