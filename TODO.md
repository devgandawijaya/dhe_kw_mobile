# Task: Send absen data to ViewModel on button click

## Completed Steps
- Read and understand lib/views/absen_view.dart and lib/viewmodels/home_viewmodel.dart
- Added sendAttendanceData method in HomeViewModel to receive and log attendance data
- Modified _absen method in absen_view.dart to gather filename, filepath, nip, tgl, jenisAbsen=1 and send to HomeViewModel
- Print console message confirming data send

## Next Steps
- Run the Flutter app
- Navigate to AbsenView
- Use 'Ambil Photo' to take a photo and generate watermarked image
- Click 'Absen Masuk' button to trigger _absen and send data to ViewModel
- Verify console log prints the attendance data and confirmation message
- Verify SnackBar 'Absen berhasil' is shown
