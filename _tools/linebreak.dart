import 'dart:io';

final int MAX_LINE_LENGTH = 73;

int main(List<String> args) {
  if (args.length < 1) {
    usage();
    return -1;
  }

  for (int i = 0; i < args.length; i++) {
    File file = new File("./${args[i]}");
    process(file);
  }

  return 0;
}

void usage() {
  print("Usage: linebreak <file1> <file2> <file3>...");
}

void process(File file) {
  StringBuffer buffer = new StringBuffer();

  file.open();
  file.readAsLinesSync().forEach((String line) {
    StringBuffer newLine = new StringBuffer();
    if (line.contains(" ")) {
      line.split(" ").forEach((String word) {
        if (newLine.length + 1 + word.length < MAX_LINE_LENGTH) {
          newLine.write("$word ");
        } else {
          buffer.write("${newLine.toString()}\n");
          newLine = new StringBuffer();
          newLine.write("$word ");
        }
      });
      buffer.write("${newLine.toString()}\n");
    } else {
      buffer.write("${line}\n");
    }
  });

  file.openWrite();
  file.writeAsStringSync(buffer.toString());
}
