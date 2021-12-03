# Example #

## sample.ini ##
```ini
[sample]
value_0=hi
value_1=/
[example]
value_0=ho
```

## ini.bat ##
```bat
...  
call :inini sample value_0 bye
call :inini sample value_1 bye
rem You have to impliment above lines into your "ini.bat" by yourself.
...  
```

## sample.bat ##
```bat
...
call ini.bat sample.ini

echo %sample.value_0%
rem hi
echo %sample.value_1%
rem bye
echo %example.value_0%
rem "Echo is on|off." cause there are no line in the "ini.bat" like "call :inini example value_0".
...
```
# About #
## Syntax ##
```bat
call :inini [sectionName=%INI_DEFAULT_SECTION_NAME%] valueName [defaultValue] [usesDoubleQuoter] [asFile] [confirmsFile] sDefaultValue] [label] [valueCollectionName]
```
## Parameters ##
### sectionName (optional) ###
Set the section name for the *valueMame*. **SETTINGS** is used as default if there is no *sectionName* in .ini file.
### valueName ###
Set the name for the value in .ini file.
### defaultValue (optional) ###
If **/** is set to the value, *defaultValue* will be replaced with it.
### usesDoubleQuotes (optional) ###
If any string is set to this parameter, the value is automatically enclosed in double quotes.
### asFile (optional) ###
When any string is set, the value of *valueName* is expected to be a path. This parameter is also expected to be a file name. When the path set is invalid, *asFile* will be searched in %*defailtValue*%, %dp0%, %PROGRAMFILES% or %PROGRAMFILES(X86)% and used as default value. If this parameter is set, *usesDoubleQuotes* will not be respected.
### confirmsFile (optional) ###
If any string is set to this parameter and also *asFile* is set, the value of *valueName* is confirmed if it's a valid path and if there are no file then console requires to input a valid path.
### usesDefaultValue (optional) ###
if any string is set, *defaultValue* is forced to be set to *valueName* even if *valueName* has certain value in .ini file.
### label (optional) ###
The value is set like "*label* value".
### valueCollectionName (optional) ###
The value is set like "!%*valueCollectionName*%[%value%]!". To impliment "%*valueCollectionName*%[...]" is needed in any .bat file.
