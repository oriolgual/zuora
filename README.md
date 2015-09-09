# Invoice2go Zuora [![Build Status](https://secure.travis-ci.org/invoice2go/zuora.png?branch=master)](http://travis-ci.org/invoice2go/zuora) [![Gemnasium](https://gemnasium.com/wildfireapp/zuora.png)](https://gemnasium.com/invoice2go/zuora)

This is a fork of Wildfire's [Zuora Ruby Library](https://github.com/zuorasc/zuora) maintained by Invoice2go.

It connects to the [Zuora SOAP API](https://knowledgecenter.zuora.com/BC_Developers/SOAP_API) and facilitates querying and modifying the Object Model using the ActiveRecord pattern.

## Requirements
  * [bundler](https://github.com/carlhuda/bundler)
  * [active_support](https://github.com/rails/rails/tree/master/activesupport)
  * [savon](https://github.com/rubiii/savon)
  * [wasabi](https://github.com/rubiii/wasabi)

All additional requirements for development should be referenced in the provided zuora.gemspec and Gemfile.

## Installation

    git clone git@github.com:invoice2go/zuora.git

## Getting Started

    $ bundle install
    $ bundle exec irb -rzuora

```
  Zuora.configure(:username => 'USER', :password => 'PASS', sandbox: true, logger: true)
    
  account = Zuora::Objects::Account.new
   => #<Zuora::Objects::Account>...

  account.name = "Test"
   => "Test"
   
  account.create
   => true
  
  created_account = Zuora::Objects::Account.find(account.id)
   => #<Zuora::Objects::Account>...
```

## Test Suite
  This library comes with a full test suite, which can be ran using the standard rake utility.

      $ rake spec

## Live Integration Suite
  There is also a live suite which you can test against your sandbox account.
  This can by ran by setting up your credentials and running the integration suite.

  **Do not run this suite using your production credentials. Doing so may destroy
  data although every precaution has been made to avoid any destructive behavior.**

      $ ZUORA_USER=login ZUORA_PASS=password rake spec:integrations

## Support & Maintenance
  This library partially supports Zuora's SOAP API version 69.0. We haven't finished migrating the entire library from 38.0 to 69.0, so consider it alpha-quality software for now. For an updated timeline of when this will become stable, contact [ataki](http://github.com/ataki) for more details.
  
  Contributions and PR's are welcome on top of master.

## Contributors
  * [ataki](http://github.com/ataki) - maintainer

## Credits
  * [Wildfire Ineractive](http://www.wildfireapp.com) for the original project

## Legal Notice

We maintain the same license as the original library.

      Copyright (c) 2013 Zuora, Inc.
	  
      Permission is hereby granted, free of charge, to any person obtaining a copy of 
	  this software and associated documentation files (the "Software"), to use copy, 
	  modify, merge, publish the Software and to distribute, and sublicense copies of 
	  the Software, provided no fee is charged for the Software.  In addition the
	  rights specified above are conditioned upon the following:
	
	  The above copyright notice and this permission notice shall be included in all
	  copies or substantial portions of the Software.
	
	  Zuora, Inc. or any other trademarks of Zuora, Inc.  may not be used to endorse
	  or promote products derived from this Software without specific prior written
	  permission from Zuora, Inc.
	
	  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	  FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
	  ZUORA, INC. BE LIABLE FOR ANY DIRECT, INDIRECT OR CONSEQUENTIAL DAMAGES
	  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
	  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
	  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
	  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
	  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.  
	
	  IN THE EVENT YOU ARE AN EXISTING ZUORA CUSTOMER, USE OF THIS SOFTWARE IS GOVERNED
	  BY THIS AGREEMENT AND NOT YOUR MASTER SUBSCRIPTION AGREEMENT WITH ZUORA.
