# University Course Timetabling Problem

### Usage

Open/add the root folder to your path in MATLAB and run:

    >> MainPage

### Input Formatting

Our problem algorithms relies on an initial input given in the form of a CSV file, that dictates important information such as student-course mappings, teacher-course mappings, room definitions, and course definitions.

For examples of valid inputs, please see the `inputs/` folder. Header lines are marked as prefixed with a `#`, and any line marked as such will be ignored when reading the file.

*Note: Header lines are for your reference only! The CSV parser will ignore them, so swapping the columns of two headers will not change how the input is read.*

Any ID column must be listed in starting from 1 monotonically-increasing order, and must match exactly with the number of entities specified on the first line (eg: 1, 2, 3, ..., numStudents).

Any input file that does not satisfy these conditions may result in undefined behaviour.

### Parameters

Each of the metaheuristic algorithms allow for certain variables to be input to tune its behaviour. These parameters are not checked for validity, so any invalid numbers may result in undefined behaviour.

### Group Members

- Kathleen Chung
- Ryan Crezel
- Christian De Angelis
- Evet Dinkha
- Jaclyne Ooi

### License

This code is available under the MIT License. Please refer to the LICENSE file in this directory for more details.
