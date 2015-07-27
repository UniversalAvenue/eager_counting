require 'test_helper'

class EagerCountingTest < ActiveSupport::TestCase
  test 'count_by a directly associated model' do
    user1 = User.create
    user2 = User.create
    Visit.create(user: user1)
    Visit.create(user: user1)
    Visit.create(user: user2)

    assert_equal({ user1.id => 2, user2.id => 1 },
                 Visit.count_by(:user))

    assert_equal({ user1.id => 2 },
                 Visit.count_by(:user, User.where(id: user1.id)))

    assert_equal(0, Visit.count_by(:user)[-1])
  end

  test 'count_by a joined model' do
    place1 = Place.create
    place2 = Place.create
    Action.create(visit: Visit.create(place: place1))
    Action.create(visit: Visit.create(place: place1))
    Action.create(visit: Visit.create(place: place2))

    assert_equal({ place1.id => 2, place2.id => 1 },
                 Action.count_by(visit: :place))

    assert_equal({ place1.id => 2 },
                 Action.count_by({ visit: :place }, Place.where(id: place1.id)))

    assert_equal(0, Action.count_by(visit: :place)[-1])
  end

  test 'count_by a distant joined model' do
    country1 = Country.create
    country2 = Country.create
    Action.create(visit: Visit.create(place: Place.create(country: country1)))
    Action.create(visit: Visit.create(place: Place.create(country: country1)))
    Action.create(visit: Visit.create(place: Place.create(country: country2)))

    assert_equal({ country1.id => 2, country2.id => 1 },
                 Action.count_by(visit: { place: :country }))

    assert_equal({ country1.id => 2 },
                 Action.count_by({ visit: { place: :country } }, Place.where(id: country1.id)))

    assert_equal(0, Action.count_by(visit: { place: :country })[-1])
  end

  test 'count_by a via has_many association joined model' do
    product1 = Product.create
    product2 = Product.create
    visit1 = Visit.create
    visit2 = Visit.create
    Action.create(visit: visit1, product: product1)
    Action.create(visit: visit1, product: product2)
    Action.create(visit: visit2, product: product1)

    assert_equal({ product1.id => 2, product2.id => 1 },
                 Visit.count_by(actions: :product))

    assert_equal({ product1.id => 2 },
                 Visit.count_by({ actions: :product }, Product.where(id: product1.id)))

    assert_equal(0, Visit.count_by(actions: :product)[-1])
  end

  test 'count_by polymorphicly associated model' do
    place1 = Place.create
    place2 = Place.create
    Comment.create(commentable: place1)
    Comment.create(commentable: place1)
    Comment.create(commentable: place2)

    assert_equal({ place1.id => 2, place2.id => 1 },
                 Comment.count_by(:commentable, Place.all))

    assert_equal({ place1.id => 2 },
                 Comment.count_by(:commentable, Place.where(id: place1.id)))

    assert_equal(0, Comment.count_by(:commentable, Place.all)[-1])
  end
end
