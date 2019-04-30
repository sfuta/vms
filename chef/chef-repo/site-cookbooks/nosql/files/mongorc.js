
// mongo shellの設定ファイル

// プロンプトの表示設定
prompt = function() {
  var base = "[" + db + "@" + hostname() + "]> ";

  var rsStateName = function(state) {
    switch(state) {
      case 0: return "STARTUP";
      case 1: return "PRIMARY";
      case 2: return "SECONDARY";
      case 3: return "RECOVERING";
      case 5: return "STARTUP2";
      case 6: return "UNKNOWN";
      case 7: return "ARBITER";
      case 8: return "DOWN";
      case 9: return "ROLLBACK";
      case 10: return "REMOVED";
    }
  }
  var rsStatus = rs.status();

  if (rsStatus.ok) {
    return "[" + rsStatus.set + ":" + rsStateName(rsStatus.myState) + "]" + base;
  } else {
    return "[mongo]" + base;
  }
}

