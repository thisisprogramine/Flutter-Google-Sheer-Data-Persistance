import 'package:google_sheets_data/model/member.dart';
import 'package:gsheets/gsheets.dart';

class MemberSheetApi {
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "membersheet-337908",
  "private_key_id": "a7a42dae2067bcb9810f741f44dfad41a7b2cbf7",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDFDJg5RaPkbANr\nPzDkC6yMgIB9x+krV0OuhND7x0uQ4E6V9OCDQXHO1tLDjsXndKS7drQq5OEVp3J0\n5RdtsApULyHMLROxmJIeL6PAVgPjdwda4EpHjtOe5b1QpG16oxfQFBbKkktBOjFI\nSU9ybO0LN2h0TGjQYZT4hHNAiDZq6tbHdTTlWoKLLmqlyLAkmuXgUz7xzp80sdRP\nTldPBZ08pWlNLuvlKUPCSUt0aY/2IRnApH4ckf/F3NzTdzLFOxi8sV4E60WO2/jv\nc5Zu9fXbnLmmi6l0k2OpJu9ulh0opUeWik45XU9jGy6EP3fzy0xaYs7LCxeWYmpv\nIYiJnIwdAgMBAAECggEAILqBDSAvQtka70UBZJs4x2RvkxSxeoilvfai9HLLbw6G\nlvsjkEF+Ou3s91y/K7ywwM9MSQSXix5zEQ3dCJOw/38NlMlW6ExQVrGwd9mBj1Yd\nk19GDyEerpl3io2o/nHY2m9/wpkuZTDabyh4COglLhP/pjNrxFK06Nss/maxbSv1\nztIfzSYz2UEzWMPafT/t1gbvpawJiYi+lrXgQzb1mMkaWVkuM0fr52FqKpfbwqR1\nnPU7wJQ0ogMfbZxHRk1/CIP2liNakHYKeSBH+uASLSmob9tm02WKpgl640fn8lz/\nKhCryN/0XXLI2eEo9oe8ohFW28GNxK/MUyyrVYvsMQKBgQD4jJAOvr+akDF8xh3F\n45bOt7CcG3LrbGqQtQ2nfnZBzEzbnnwhudqYMfnVKOK6KZHx7hoRjWqhgXitZGPS\nv07P+k/TJYr34xccIBu/cGWtEDxwkkOFuy8VTIcwmcf9V7QRPfiF/sqcFmRQaQGo\nLvyIUumNOPN3/Mv5tvHwVHR50QKBgQDK9M6Xovx1iuNT0EU2Cds1StL8MRGlFPVR\ngLaAS1ezQuR+mMLf+6spkP8nFgRCq4de9mRI2fc6R4ZmS8mwmBfX8WBGpnC7XRM4\na63p1ybqlNp3IJLjLX9r3odk7WXtk0R3MJAvuxByIiYkZGTlfTbIRFzRk04208OP\nN5hciAc0jQKBgE+foCrJGtKmLORfB3y0u0Q//nkUJg2bbswq5FPrJHFRxLF6pSOc\nyZWGNRX/ghrHZHTPpVRILIfO1V0e0wfZt6LS+q2W0l01R9r/wkPi+v+lOueJQ85c\nt+mn2YtNSI81gH8hjjNG+5tjZQGJkjlRzB7UCPPv8bdXqfS2ke0+8Q1xAoGAavIR\nIuppqe6j13h53/3VmwFwqB+bMqgWlPoEMRqCfh2TlfodRjWxfde/+/KoEBGe5bVk\nJtdkZTtnYOQyxXF/rvSsTM5LvQ9Qn3xuSjhrc1U4wWlSvY8uA8NhCRfnjAb8Hupi\nMCSch+fivW6BlEQk5+bOGklK/60a8Y7UJH4xfckCgYEAxRJoRNYYx69XqmonSdeP\nAo19zm665UEdVcviQkVk7VtpQkV0Lavsqxm8gpixUmLFG0+4/75AEZQRYAm6mQvh\nFxkQqx6Y7abvN3z4eXF723lqz/iWPEj4d9I40Dk79QYHmBOFlXMtOO2f3lESXava\niPtZpCKMfYRsZsI+eBk/or0=\n-----END PRIVATE KEY-----\n",
  "client_email": "membersheet@membersheet-337908.iam.gserviceaccount.com",
  "client_id": "111360158726791428250",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/membersheet%40membersheet-337908.iam.gserviceaccount.com"
}

  ''';
  static final _spreadsheetId = '1w3TUzAMcCVTgfqSu896gJ6WHG8ADdFln-68_a5Gd3jE';
  static final _gsheet = GSheets(_credentials);
  static Worksheet? _memberSheet;

  static Future init() async {
    try{
      final spreadsheet = await _gsheet.spreadsheet(_spreadsheetId);
      _memberSheet = await _getWorkSheet(spreadsheet, title: 'MemberSheet');

      final firstRow = MemberFields.getFields();
      _memberSheet!.values.insertRow(1, firstRow);
    } catch(e) {
      print('Init Error: $e');
    }

  }

  static Future<Worksheet> _getWorkSheet(
      Spreadsheet spreadsheet, {required String title}
      ) async {
    try{
      return await spreadsheet.addWorksheet(title);
    } catch(e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future insert(List<Map<String, dynamic>> rowList) async{
    if(_memberSheet == null)
      return;

    await _memberSheet!.values.map.appendRows(rowList);
  }

  static Future<int> getRowCount() async {
    if(_memberSheet == null) return 0;

    final lastRow = await _memberSheet!.values.lastRow();
    return lastRow == null ? 0 : int.tryParse(lastRow.first) ?? 0;
  }

  static Future<Members?> getById(int id) async{
    if(_memberSheet == null) return null;
    final json = await _memberSheet!.values.map.row(id, fromColumn: 1);
    return json == null ? null : Members.fromJson(json);
  }

  static Future<List<Members>> getAll() async{
    if(_memberSheet == null) return <Members>[];

    final members = await _memberSheet!.values.map.allRows();
    
    return members == null ? <Members>[] : members.map(Members.fromJson).toList();
  }

  static Future<bool> update(int id, Map<String, dynamic> member) async {
    if(_memberSheet == null) return false;

    return await _memberSheet!.values.map.insertRowByKey(id, member);
  }

  static Future<bool> updateCell({required int id, required String key, required dynamic value}) async {
    if(_memberSheet == null) return false;

    return await _memberSheet!.values.insertValueByKeys(value, columnKey: key, rowKey: id);
  }

  static Future<bool> deleteById(int id) async {
    if(_memberSheet == null) return false;

    final index = await _memberSheet!.values.rowIndexOf(id);
    if(index == -1) return false;

    return await _memberSheet!.deleteRow(index);
  }
}