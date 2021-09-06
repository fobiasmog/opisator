# Opisator

The main idea of this gem is to remove any logic from controllers and simply **describe**, how a controller should work with request and it's data.

You feel free to use any gems and conceptions (for example: dry-rb, interaction gems, json serializers) inside you contract, interactor and presenter moudles

```ruby
class IndexController < ApplicationController
  include Opisator

  opisator_for :index

  def index
    @contract = MyContracts::Index
    @interactor = MyInteractors::Index
    @presenter = MyPresenters::Index
  end
end
```

There is the simple pipline of interaction:
```
request -> contract(params) -> interactor(contract_result) -> presenter(interactor_result) -> render(presenter_result)
```

### Contracts
Params from request are passing directly to contract module, so you can validate, permit and change it whatever you want.

```ruby
class Contracts::Index
  def call(params)
    validate_and_return_params
  end
end
```

### Interactors
Any business-logic is should be inside interactor

```ruby
class Interactors::Index
  def call(params)
    pp 'index interactor'
  end
end
```
### Presenters
Presenters are using for prepare data to render. You have to return hash, which pass to rails render function

```ruby
class Presenters::Index
  def call(params)
    {
      json: { ok: true },
      status: 201
    }
  end
end
```
