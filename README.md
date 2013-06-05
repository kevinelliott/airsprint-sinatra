# airsprint-sinatra

A lightweight Airbrake to Sprint.ly WebHook bridge implemented with Sinatra.

## About

airsprint-sinatra publishes exceptions received by Airbrake to Sprint.ly. When Airbrake receives exceptions from your application, the WebHook defines on Airbrake is triggered and calls airsprint, which then creates a defect on Sprint.ly using the Sprint.ly REST API. 

[Airbrake](http://airbrake.io) is an exception detection and reporting service that can be used with many languages and platforms. I personally use it with Rails by using their `airbrake` gem.

[Sprint.ly](http://sprint.ly) is an agile sprint tracking feature planning tool that also offers the ability to track tests and defects (bugs). It is a relatively new but popular alternative to [Pivotal Tracker](http://pivotaltracker.com) with the advantages of a clean, attractive interface and a simpler workflow.

## Project Status

### Functional initial hack release, but could use improvement.

This lightweight application is functional and will receive error notifications from Airbrake for multiple applications (you will create a separate WebHook for each application). Additionally, airsprint is *relatively* secure because it supports a password that must be defined in the app config so it can not be called by arbitrary unauthorized users (still need https support to make this more secure).

Consider this application a base for your own Airbrake to Sprint.ly (or other target endpoints). I do intend to improve this over time, as well as integrate user contributions.

## Installation

1.  Check out the repository.

    `git clone https://github.com/kevinelliott/airsprint-sinatra.git`

2.  Change into the cloned directory.

    `cd airsprint-sinatra`

3.  Copy the `sample.config.yml` to `config.yml`.

    `cp sample.config.yml config.yml`

4.  Edit the new `config.yml`. Set a password for the Airbrake WebHooks, as well as your Sprint.ly credentials.

## Deployment on Heroku

1.  Set the Heroku production environment variables

        heroku config:set AIRSPRINT_PASSWORD=1234567890
        heroku config:set SPRINTLY_EMAIL=user@example.com
        heroku config:set SPRINTLY_API_KEY=ABCDEFGHIJKLMNOPQRSTUVWXYZ
        heroku config:set SPRINTLY_DEFAULT_PRODUCT_ID=12345

    Sprint.ly `product_id`'s can be passed in each Airbrake WebHook, but it will fall back to the `SPRINTLY_DEFAULT_PRODUCT_ID` if none is provided.

2.  Create the heroku app to correspond with my_app (whatever your app name is). This name can be anything you want.

    `heroku create my-app-airsprint`

3.  Deploy airsprint to heroku.

    `git push heroku master`

## Setup Airbrake

1.  On your project page on Airbrake, click on the `Add Integration` button.

2.  Choose `Webhook`.

3.  Enter the URL to your airsprint installation along with the correct integration endpoint, specifying the password you set above for `AIRSPRINT_PASSWORD` as an argument on the URL.

    `http://my-app-airsprint.herokuapp.com/integrations/airbrake?password=1234567890`

    Optionally, you may specify the Sprint.ly `project_id` that this particular Airbrake project corresponds with. This allows you to have multiple Airbrake projects create defects on multiple Sprint.ly projects that your email/api_key has access to.

    `http://my-app-airsprint.herokuapp.com/integrations/airbrake?password=1234567890&project_id=12345`

## That's It!

Now anytime your Airbrake project receives exceptions from your actual application, you will receive requests to airsprint, which will then forward to Sprint.ly and create a defect.

## Future Plans

Whenever I can muscle up the free time, I intend to expand this to support other destination endpoints that Airbrake doesn't support, and perhaps even some inbound services besides Airbrake (such as Sentry, etc).

More importantly, I'd like to make the Sprint.ly item creation more configurable, perhaps via templating.

## Maintainer

* Kevin Elliott - [kevinelliott.net](http://kevinelliott.net) - [github.com/kevinelliott](http://github.com/kevinelliott)
* WeLike - [www.welikeinc.com](http://www.welikeinc.com) - [github.com/welike](http://github.com/welike)

## Contributors

As contributions come in via pull requests, I will update this list to credit the kind souls who help out.

## License

(The MIT License)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
