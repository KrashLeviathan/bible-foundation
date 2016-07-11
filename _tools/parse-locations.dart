import 'dart:io';

int main(List<String> args) {
  if (args.length < 1) {
    usage();
    return -1;
  }

  for (int i = 0; i < args.length; i++) {
    File file = new File("./${args[i]}");
    bool successful = process(file);
    if (!successful) {
      print("Location Parsing Unsuccessful. Exiting.");
      return -1;
    }
  }

  return 0;
}

void usage() {
  print("Usage: locations <file1> <file2> <file3>...");
}

/// Adds 2 spaces for each indent level.
String spaces(int indentLevel) {
  String str = "";
  for (int i = 0; i < indentLevel; i++) {
    str += "  ";
  }
  return str;
}

bool process(File file) {
  StringBuffer buffer = new StringBuffer();
  List<String> section = new List();

  buffer.write('{\n');
  buffer.write('${spaces(1)}"locations": [\n');

  file.open();
  file.readAsLinesSync().forEach((String line) {
    if (line.isNotEmpty) {
      print(line);
      section.add(line);
    } else {
      print("");
      processSection(buffer, section);
      section = new List();
    }
  });

  buffer.write('${spaces(1)}]\n');
  buffer.write('}\n');

  File output = new File("./parse-locations-output.json");
  output.openWrite();
  output.writeAsStringSync(buffer.toString());
  return true;
}

void processSection(StringBuffer buffer, List<String> section) {
  buffer.write('${spaces(2)}{\n');
  print('''
  Enter one letter for each line in the address above (Q to quit):

  t - title                 f - fax
  c - care of               w - website
  b - PO box                e - email
  a - street address        1 - other1
  s - state line            2 - other2
  p - phone1                3 - other3
  P - phone2                C - Country
  ''');
  try {
    String input = stdin.readLineSync();
    print("\n###################################################\n\n");
    for (int i = 0; i < section.length; i++) {
      processLine(buffer, section[i], input[i], i == section.length - 1);
    }
    buffer.write('${spaces(2)},\n');
  } catch (e) {
    print(e);
    buffer.write('${spaces(2)},\n');
  }
}

void processLine(
    StringBuffer buffer, String line, String letter, bool lastLine) {
  line = line.trim();
  if (line.contains('"')) {
    line.replaceAll('"', r'\"');
  }
  String jsonLine(String key) =>
      '${spaces(3)}"${key}": "${line}"${(lastLine) ? '' : ','}\n';
  switch (letter) {
    case 't':
      buffer.write(jsonLine('title'));
      break;
    case 'c':
      buffer.write(jsonLine('care_of'));
      break;
    case 'b':
      buffer.write(jsonLine('po_box'));
      break;
    case 'a':
      buffer.write(jsonLine('street_address'));
      break;
    case 's':
      processCityStateZip(buffer, line);
      break;
    case 'p':
      buffer.write(jsonLine('phone1'));
      break;
    case 'P':
      buffer.write(jsonLine('phone2'));
      break;
    case 'f':
      buffer.write(jsonLine('fax'));
      break;
    case 'w':
      buffer.write(jsonLine('website'));
      break;
    case 'e':
      buffer.write(jsonLine('email'));
      break;
    case '1':
      buffer.write(jsonLine('other1'));
      break;
    case '2':
      buffer.write(jsonLine('other2'));
      break;
    case '3':
      buffer.write(jsonLine('other3'));
      break;
    case 'C':
      buffer.write(jsonLine('country'));
      break;
    case 'Q':
      exit(-1);
      break;
    default:
      buffer.write(jsonLine('unknown'));
      break;
  }
}

void processCityStateZip(StringBuffer buffer, String line) {
  List<String> commaSplit = line.split(',');
  if (commaSplit.length != 2) {
    throw new Exception("Splitting the city and state/zip by comma failed!");
  }
  String city = commaSplit[0];
  List<String> spaceSplit = commaSplit[1].trim().split(' ');
  if (spaceSplit.length != 2) {
    throw new Exception("Splitting the state and zip by space failed!");
  }
  String state = spaceSplit[0];
  String zip = spaceSplit[1];
  buffer.write('${spaces(3)}"city": "${city}",\n');
  buffer.write('${spaces(3)}"state": "${state}",\n');
  buffer.write('${spaces(3)}"zip": "${zip}",\n');
}
