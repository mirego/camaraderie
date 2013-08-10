# Camaraderie

[![Gem Version](https://badge.fury.io/rb/camaraderie.png)](https://rubygems.org/gems/camaraderie)

Camaraderie takes away the pain of managing membership stuff between users and organizations.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'camaraderie'
```

Then run the task to generate the migration:

```bash
$ rails generate camaraderie:install
```

## Usage

First, you have to configure which type of memberships you want. Usually, you’d do this in `./config/initializers/camaraderie.rb`:

```ruby
Camaraderie.configure do |config|
  # The different types of memberships (defaults to `['admin']`)
  config.membership_types = %w(admin moderator member)

  # The class name of the organization model (defaults to `'Organization'`)
  config.organization_class = 'Company'

  # The class name of the user model (defaults to `'User'`)
  config.user_class = 'Employee'
end
```

Then, you can include the two provided modules into your `User`, `Organization` and `Membership` models:

```ruby
class User < ActiveRecord::Base
  acts_as_user
end

class Organization < ActiveRecord::Base
  acts_as_organization
end

class Membership < ActiveRecord::Base
  acts_as_membership
end
```

You’re pretty much done after that. You’re now able to do this:

```ruby
user = User.find(1)
organization = Organization.find(1)

# Add the user as an admin
organization.admins.create(user: user)

# Add the user as a regular member
organization.members.create(user: user)

# Check whether the user is an admin
user.admin_of?(organization)
# => true
```

## License

`Camaraderie` is © 2013 [Mirego](http://www.mirego.com) and may be freely distributed under the [New BSD license](http://opensource.org/licenses/BSD-3-Clause).  See the [`LICENSE.md`](https://github.com/mirego/camaraderie/blob/master/LICENSE.md) file.

## About Mirego

Mirego is a team of passionate people who believe that work is a place where you can innovate and have fun. We proudly build mobile applications for [iPhone](http://mirego.com/en/iphone-app-development/ "iPhone application development"), [iPad](http://mirego.com/en/ipad-app-development/ "iPad application development"), [Android](http://mirego.com/en/android-app-development/ "Android application development"), [Blackberry](http://mirego.com/en/blackberry-app-development/ "Blackberry application development"), [Windows Phone](http://mirego.com/en/windows-phone-app-development/ "Windows Phone application development") and [Windows 8](http://mirego.com/en/windows-8-app-development/ "Windows 8 application development") in beautiful Quebec City.

We also love [open-source software](http://open.mirego.com/) and we try to extract as much code as possible from our projects to give back to the community.
