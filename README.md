# Password Generator
This is a simple gem to generate random password.

It supports follow options:
- `length` — (integer) length of the generated password
- `uppercase` — (boolean) include one or more uppercase A-Z characters
- `lowercase` — (boolean) include one or more lowercase a-z characters
- `number` — (integer) exact number of numeric 0-9 characters
- `special` — (integer) exact number of special @%!?*^& characters

*If any of given options is invalid, it raises InvalidOption error*

## Installation
```
git clone git@github.com:iambanklee/password_generator.git
cd password_generator
bundle install
```

## Test
- RSpec with 100% coverage
- 100% test coverage doesn't guarantee it's bug free but I have tested it based on my available time
```
bundle exec rspec

PasswordGenerator::Generator
  #run
    generates password in given length
    when uppercase options is false
      generates password does not contains uppercase characters
    when lowercase options is false
      generates password does not contains lowercase characters
    when number options is given
      generates password contains exactly given number times
    when special options is given
      generates password contains exactly given special times
  parameter validation
    when length is not an integer
      behaves like InvalidOption
        raises InvalidOption error
    when uppercase is not a boolean
      behaves like InvalidOption
        raises InvalidOption error
    when lowercase is not a boolean
      behaves like InvalidOption
        raises InvalidOption error
    when number is not an integer
      behaves like InvalidOption
        raises InvalidOption error
    when special is not an integer
      behaves like InvalidOption
        raises InvalidOption error
    when sum of number and special is more than length
      behaves like InvalidOption
        raises InvalidOption error

PasswordGenerator
  has a version number
  self.run
    calls generator#run

Finished in 0.0107 seconds (files took 0.66944 seconds to load)
13 examples, 0 failures

Coverage report generated for RSpec to ./coverage. 162 / 162 LOC (100.0%) covered.
```

## Use this generator in other project
- This gem is **not** released to public so the only way to install it is from local
- [an example project is pushed here](https://github.com/iambanklee/password-project) for demonstration purpose

### Installation from local
1. make sure you have clone the repository from https://github.com/iambanklee/password_generator
```
git clone git@github.com:iambanklee/password_generator.git
```
2. Go to that folder and build the gem locally
```
cd password_generator
gem build password_generator

# the version might be different - 1.0.1 is the version at writing this document.
# please use the result from above command to avoid any errors
gem install password_generator-1.0.1.gem 
```
3. Update your gemfile to include this gem
```
# path might vary depends on where you clone this gem
gem 'password_generator', path: './password_generator'
```
4. Run bundler (Gemfile is default to the path ./password_generator)
```
cd ..
bundle install
```

## Usage
This project includes a bundle command for easy usage. Following is an example:
```
bundle exec bin/generate

# length: 10, uppercase: true , lowercase: true, number: 3, special: 3 
u6eT6h^4!!
```

## Implementation approaches explained
1. The very basic function to generate password were implemented in a big single method with TDD approach. 
Which doesn't consider validations and number/special characters. 
The idea was to make it a MVP first then iterate.
2. Validation on options take most of time. Especially when new Rubocop rules involves in new projects  
3. The way to make sure number/special show exactly times is to calculate uniq positions of each. 
This approach is more suitable with the original implementation (using generation buckets). Alternative approaches could be:
   - replacement: similar to calculating position. But generate password all based on general buckets, then replace these positions with number/special characters
   - shuffle: generate all passwords based on given options, then shuffle it at the end to make sure password are randomised

### Further enhancement ideas
1. These options could be extract to its own class/validation. I decided not to over-engineering it because these options rarely change. Happy to discuss
2. As there are different approaches on how password is generated, we could implement it with Strategy pattern. But again decided not to over-engineering it. Happy to discuss
3. This generator doesn't check password strength. Could be a good extra
4. A parser to validate if given password matches options (reverse engineering/validation). This would be handy if we need to validate if given password matches our rules. Which could an enhancement combined with point 1

### Issues encounter
1. Rubocop rules
2. While installing this gem locally, it somehow install a different version, which causes a bit of debugging. Ended up nuking all gems and rebuild/reinstall from local (maybe someone published it?)
