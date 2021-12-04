# Table of contents #
- [Example](#example)
  * [sample.ini](#sampleini)
  * [ini.bat](#inibat)
  * [sample.bat](#samplebat)
- [Example with *fetchesAuto*](#example-with-fetchesauto)
  * [ini.bat](#inibat-1)
  * [sample.bat](#samplebat-1)
- [Usage](#usage)
- [Syntax](#syntax)
  * [Parameters](#parameters)
    + [sectionName (optional)](#sectionname-optional)
    + [valueName](#valuename)
    + [defaultValue (optional)](#defaultvalue-optional)
    + [usesDoubleQuotes (optional)](#usesdoublequotes-optional)
    + [asFile (optional)](#asfile-optional)
    + [confirmsFile (optional)](#confirmsfile-optional)
    + [usesDefaultValue (optional)](#usesdefaultvalue-optional)
    + [label (optional)](#label-optional)
    + [valueCollectionName (optional)](#valuecollectionname-optional)
    + [comment (optional)](#comment-optional)

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
rem You have to impliment some lines like above into your "ini.bat" by yourself for the handling value easily.
...  
```

## sample.bat ##
```bat
call ini.bat sample.ini

echo %sample.value_0%
rem hi
echo %sample.value_1%
rem bye
echo %example.value_0%
rem "Echo is on|off." cause there are no line in the "ini.bat" like "call :inini example value_0".
```
# Example with *fetchesAuto* #
## ini.bat ##
Nothing to do.
## sample.bat ##
```bat
call ini.bat sample.ini 1
rem Set any string to 2nd argument.

echo %sample.value_0%
rem hi
echo %sample.value_1%
rem /
echo %example.value_0%
rem ho
```
# Usage #
```bat
call ini.bat [iniFilePath] [fetchesAuto]
```
Put a line like an above one into your .bat. *iniFilePath* is a path for .ini. **settings.ini** is used if that was empty. *fetchesAuto* is a flag which fetches all values in the *iniFilePath* automatically. Set any string to there to enable it. Note that you can still call **[:inini](#Syntax)** any number of times in the **ini.bat** even if that flag is on. That will overwrite the corresponded value fetched by the flag.

If *iniFilePath* does not exist, *iniFilePath* will be created automatically as **[:inini](#Syntax)** specified.
# Syntax #
```bat
call :inini [sectionName=%INI_DEFAULT_SECTION_NAME%] valueName [defaultValue] [usesDoubleQuoter] [asFile] [confirmsFile] sDefaultValue] [label] [valueCollectionName] [comment]
```
Put as many lines as needed at specified position in **ini.bat**.
## Parameters ##
### sectionName (optional) ###
Set the section name for the *valueMame*. **settings** is used as default if there is no *sectionName* in .ini file.
### valueName ###
Set the name for the value in .ini file.
### defaultValue (optional) ###
If **/** is set to the value of *valueName*, *defaultValue* will be replaced with it.
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
### comment (optional) ###
*comment* will be inserted as a comment in the next line of the parameter. *comment* must be enclosed in double quotes if that has white-space. 