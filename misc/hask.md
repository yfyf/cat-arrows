Why `Hask` is and isn't a category
==================================

Whenever people start talking about `Hask` -- the category of Haskell types and
functions -- there always seem to be two camps: those pointing out the failure
of numerous categorical laws in `Hask` and those defending such interpretation
as intuitively or morally correct.

Both parties have some reasonable arguments for their stance. Here I shall try
to illuminate the seemingly complicated situation by taking a neutral view.

The simple intuition: `Hask` is a CCC category
-----------

One usually identifies the category of Haskell, `Hask` as a category consisting
of:

* the objects of `Hask` are types
* morphisms $f: a \to b$ are simply Haskell functions `f :: a -> b`
* composition of morphisms is just composition of functions, i.e.
     $(g: b \to c) \circ (f: a \to b) =$ `g . f :: a -> c`

At first sight, this seems to work rather well, all the category laws seem to
satisfied straightforwardly:

* Identity:

      For every object $a$, we have a morphism $id_a : a \to a$, which is
      given by the identity function `id :: (a -> a)`.

      Moreover, for every morphism $f: a \to b$, we have that
      $id_b \circ f = f = f \circ id_a$, since given `f :: a -> b`, we obtain

                id_a = id :: (a -> a)
                id_b = id :: (b -> b)
                id_b . f = f = f . id_a

* Associativity

      Composition should be associative:

            f . (g . h)       =      (f . g) . h

      This can be shown by rewriting the expression as lambda terms

            \x -> f (g (h x)) =  \x -> (\y -> f (g y)) (h x)

      and applying $\beta$-reduction on the internal part of the RHS (we can do
      this because of the Church-Rosser theorem) to get:

            \x -> f (g (h x)) =  \x -> f (g (h x)))

Things seem good, assuming lambda calculus is faithfully implemented in
Haskell, we can say `Hask` is a category.

Just being a category is quite boring, lets see what additional structure there
is in `Hask` (there is something wrong with all of these, but lets ignore it
for now):

* _initial object_:

    A type with no inhabitants can be defined as an algebraic data type `data Empty`
    with no constructors.

    Initial objects need a unique morphism from them to any other object, which is
    a function `f_a :: Empty -> a` for every type `a` in `Hask`.

    A moments thought will tell you that, since we know nothing about the type
    `a`, the only possible inhabitant of `a` we can think of is `undefined`.
    That is, we define the function

        f_a _ = undefined :: a

    Moreover, intuitively we can see that this function is unique: no other
    function behaving differently from `undefined` can produce an inhabitant of
    *all* types.

* _terminal_ object:

    We need a type with a single inhabitant for this. Ignoring `undefined`, this is
    achieved by the unit type, which can be defined as

        data () = ()

    and then a function for every type `a`:

        f_a _ = ()

    Again, intuitively we see that this morphism is unique, since `()` is the only
    constructor for this type.

* _products_: for all types $a$, $b$, we have a
product type $a \times b$, which in Haskell is simply the tuple `(a, b)`, with
projections given by:

        fst :: (a, b) -> a
        fst (x, y) = x

        snd :: (a, b) -> b
        snd (a, b) = b

    Moreover they satisfy the universal property of products. That is, given
    `f :: c -> a` and `g :: c -> b` we can construct

        z :: c -> (a, b)
        z = prd f g where
            prd f g = \c -> (f c, g c)

    And we also have that `fst . z = f` and `snd . z = g`.

* _coproducts_: this is achieved via a sum type of the form

            data Sum a b = Inj_1 a | Inj_2 b

      and injection functions `inj_1 x = Inj_1 a` and `inj_2 = Inj_2`.

* _exponentials_: exponential objects are probably the first interesting thing
  in this bunch.

    Given objects `a` and `b`, we want an object `b^a` with an associated
    `eval` morphism. In Haskell `b^a` corresponds to the function type `a -> b`
    (which always exists!), the `eval` morphism is just the uncurried function
    application, i.e. `uncurry ($) :: (a -> b, a) -> b` operator [or
    alternatively, the uncurried identity map `id :: (a -> b) -> (a -> b)`].

    Moreover, given `g :: (c, a) -> b` we can curry it to obtain
    `curry g :: c -> (a -> b)` and clearly this is commutative with the `eval`
    morphism:

        g = eval . (cross (curry g) id) where
            cross f g = \(a, b) -> (f a, g b)

    which can be expressed using arrows much more neatly as

        g = (curry g) *** id >>> eval


The fact that `Hask` has a terminal object, products and exponentials tells us
that it is in fact a Cartesian closed category.


The ugly parts of `Hask`
-----------

Everything goes bad with lazy evaluation combined with `undefined`. If one also
combines that with the possible strictness enforcement (via `seq`), then even
the basic category laws fail.

However, if we try to "remove" `undefined`, we loose initial and terminal
objects, so `Hask` is no longer a CCC.

The morally correct reasoning about `Hask`
-----------





References
==========

* [Wikibooks, Haskell/Category theory](https://en.wikibooks.org/wiki/Haskell/Category_theory)
* [Haskell wiki: Hask](http://www.haskell.org/haskellwiki/Hask#Is_Hask_even_a_category.3F)
* [Haskell wiki: Bottom type](http://www.haskell.org/haskellwiki/Bottom)
* Danielson et al. "Fast and Loose Reasoning is Morally Correct
* [Category Theory and the category of Haskell programs](http://www.alpheccar.org/content/74.html)
* ["What Category do Haskell Types and Functions Live In?"](http://blog.sigfpe.com/2009/10/what-category-do-haskell-types-and.html?showComment=1256651135314#c8619272017494916336)
* ["Haskell functors versus "real" functors"](http://bytbox.net/blog/2013/09/haskell-functors-versus-real-functors.html)
