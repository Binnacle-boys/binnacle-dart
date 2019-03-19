# Route Planning

The route planning portion of the project.

## Installing
Once you've pulled a branch containing this directory, cd into route_planning and install the necessary packages with:
``` bash
pip3 install -r ./requirements.txt
```

## How to use
This is a two part process (so far.) If you have any questions about a command, try running it with the -h flag.

### Generate data
To generate bogus input, run:
```
python3 generate_bogus_input.py [options] <output_path>
```
Consider using the -n flag to specify a number of entries, default is 10. For the sake of this example, lets say we called it example_input.yaml.

### Using the data
Next we want to use the data. I wanted to be able to compare different groups of algorithms so if you look in test_config.yaml, you will find an example group that looks like this:
```
group1:
  - test01_alg
  - test02_alg
```
The group's name is group1 and it includes two algorithms. These algorithms (test01_alg and test02_alg) are located in algorithm_modules/test01_alg.py and test02_alg.py. In order to run the input data we made in the earlier step (example_input.yaml) on the algorithms in group1, we would run:
```
python3 alphabet_test [options] example_input.yaml <output_path>
```
And violá, the results should be in whatever file you used for `<output_path>`

Slack me (Daniel) if you have any Q's


