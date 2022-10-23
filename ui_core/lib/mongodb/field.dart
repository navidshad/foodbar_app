/// {@nodoc}
library mongo_field;

enum FieldType {
  text,
  textbox,
  number,
  checkbox,
  select,
  multiSelect,
  object,
  array,
  showLength,
  dateTime,
  date,
  image,
}

enum DataType {
  string,
  bool,
  int,
  float,
  object,
  array_string,
  array_object,
  dateTime
}

extension BoolParsing on bool {
  static bool parse(String value) {
    if (value == 'true')
      return true;
    else
      return false;
  }
}

class DbField {
  // the main key of object property.
  String key;
  // the custom title of this property
  late String title;
  // the data type of this property
  DataType dataType;
  // the type of field for this property
  FieldType fieldType;
  // value of this obtion for select FieldType type.
  String? strvalue;

  // the field of this property could be disable
  bool isDisable;
  // the field of this property could be hide
  bool isHide;

  // convert strings to lower case mode
  bool isLowerCase;

  //only for map type
  List<DbField>? subFields;

  DbField(
    this.key, {
    String? customTitle,
    this.strvalue,
    this.dataType = DataType.string,
    this.fieldType = FieldType.text,
    this.isDisable = false,
    this.isHide = false,
    this.isLowerCase = false,
    this.subFields,
  }) {
    title = customTitle ?? key;
    if (strvalue == null) strvalue = key;
    if (fieldType == null) setDefaultFields();
  }

  static casteValue(DataType dataType, dynamic value) {
    dynamic parsed;

    switch (dataType) {
      case DataType.string:
        parsed = value.toString();
        break;

      case DataType.bool:
        parsed = BoolParsing.parse(value.toString());
        break;

      case DataType.float:
        parsed = double.parse(value.toString());
        break;

      case DataType.object:
        parsed = value as Map;
        break;

      case DataType.array_string:
        parsed = (value as List).map((f) => f.toString()).toList();
        break;

      default:
        parsed = value;
    }

    return parsed;
  }

  void setDefaultFields() {
    //fieldType =FieldType.text;
    switch (dataType) {
      case DataType.string:
        fieldType = FieldType.text;
        break;
      case DataType.int:
        fieldType = FieldType.text;
        break;
      case DataType.float:
        fieldType = FieldType.text;
        break;
      case DataType.bool:
        fieldType = FieldType.checkbox;
        break;
      case DataType.object:
        fieldType = FieldType.object;
        break;
      case DataType.array_string:
        fieldType = FieldType.select;
        break;
      case DataType.array_object:
        fieldType = FieldType.select;
        break;
      case DataType.dateTime:
        fieldType = FieldType.text;
        break;
    }
  }

  String extractTitlesForStrValues(Map object) {
    String extracted = '';

    List<String> arr = object[key] as List<String>;

    // groups loop
    if (subFields != null) {
      subFields!.forEach((group) {
        // subgroup loop
        group.subFields!.forEach((subF) {
          if (arr.indexOf(subF.strvalue!) != -1) extracted += subF.title + ", ";
        });
      });
    }

    return extracted;
  }

  String extractTitleForStrValue(Map object) {
    String value = object[key];

    if (subFields != null) {
      subFields!.forEach((sdf) {
        if (sdf.strvalue == value) value = sdf.title;
      });
    }

    return value;
  }

  // title should be generated for these types: select, multiSelect
  String generateTtitle(Map row) {
    String value = row[key].toString();

    if (fieldType == FieldType.select)
      value = extractTitleForStrValue(row);
    else if (fieldType == FieldType.multiSelect)
      value = extractTitlesForStrValues(row);
    else if (fieldType == FieldType.object) {
      Map tempObj = row[key] as Map;
      value = '';
      tempObj.keys.forEach((key) => value += '${tempObj[key]}, ');
    } else if (fieldType == FieldType.array &&
        dataType == DataType.array_object) {
      value = '';
      row[key].forEach((Map obj) {
        value = "\n";
        obj.remove('_id');
        obj.keys.forEach((key) => value += '${obj[key]}, ');
      });
    } else if (fieldType == FieldType.showLength)
      value = row[key].length.toString();
    else if (fieldType == FieldType.dateTime) {
      value = row[key].toString();

      try {
        DateTime temp = DateTime.parse(value);
        value =
            temp.toLocal().toIso8601String().split('T').join(' ').split('.')[0];
      } catch (e) {}
    } else if (fieldType == FieldType.date) {
      value = row[key].toString();

      try {
        DateTime temp = DateTime.parse(value);
        value = temp.toLocal().toIso8601String().split('T')[0];
      } catch (e) {}
    }

    return value;
  }
}
