(* Distributed under the terms of the MIT license.   *)
Set Warnings "-notation-overridden".
Require Import ssreflect.

From Equations Require Import Equations.
From Coq Require Import String Bool List Utf8 Lia.
From MetaCoq.Template Require Import config utils monad_utils.
From MetaCoq.PCUIC Require Import PCUICAst PCUICLiftSubst PCUICTyping
  PCUICReduction PCUICWeakening PCUICEquality PCUICUnivSubstitution
  PCUICParallelReduction PCUICParallelReductionConfluence PCUICInduction
  PCUICRW PCUICPattern.

(* Type-valued relations. *)
Require Import CRelationClasses.
Require Import Equations.Prop.DepElim.
Require Import Equations.Type.Relation Equations.Type.Relation_Properties.

Import MonadNotation.

Set Asymmetric Patterns.

Set Default Goal Selector "!".

Open Scope string_scope.

Existing Instance config.default_checker_flags.

Definition nouniv :=
  Monomorphic_ctx (
    {| LS.this := [] ; LS.is_ok := LevelSet.Raw.empty_ok |},
    {| CS.this := [] ; CS.is_ok := ConstraintSet.Raw.empty_ok |}
  ).

(** TypeCastCIC *)

Definition headerpath := MPfile [ "header" ].

Definition headerpath := MPfile [ "header" ].

Definition headerdecl :=
  InductiveDecl {|
    ind_finite := Finite ;
    ind_npars  := 0 ;
    ind_params := [] ;
    ind_bodies := [
      {|
        ind_name := "header" ;
        ind_type := tSort {|
          Universe.t_set := {|
            UnivExprSet.this := [ UnivExpr.npe (NoPropLevel.lSet, false) ] ;
            UnivExprSet.is_ok :=
              UnivExprSet.Raw.singleton_ok
                (UnivExpr.npe (NoPropLevel.lSet, false))
          |} ;
          Universe.t_ne := eq_refl
        |} ;
        ind_kelim := InType ;
        ind_ctors := [
          ("hUniv", tProd nAnon (tRel 0) (tRel 1), 1) ;
          ("hProd", tRel 0, 0) ;
          ("hInd", tRel 0, 0)
        ] ;
        ind_projs := []
      |}
    ] ;
    ind_universes := Monomorphic_ctx (
      {| LS.this := [] ; LS.is_ok := LevelSet.Raw.empty_ok |},
      {| CS.this := [] ; CS.is_ok := ConstraintSet.Raw.empty_ok |}
    ) ;
    ind_variance := None
  |}.

Definition Σheader := [ ((headerpath, "header"), headerdecl) ].

Lemma on_header :
  on_global_decl (PCUICEnvTyping.lift_typing typing) ([], nouniv)
    (headerpath, "header") headerdecl.
Proof.
  cbn. constructor.
  - constructor. 2: constructor. econstructor.
    + instantiate (2 := []). cbn. reflexivity; cbn.
    + eexists. admit.
    + red. admit.
    + contradiction.
    + red. constructor.
      * red. instantiate (1 := []). cbn. apply Forall_nil.
      * reflexivity.
  - cbn. constructor.
  - cbn. reflexivity.
  - admit.
Admitted.

Lemma wf_Σheader :
  wf Σheader.
Proof.
  constructor.
  - constructor.
  - constructor.
  - red. cbn. intuition auto.
    + red. intros l h1 h2. inversion h1.
    + red. intros [[? ?] ?] h. inversion h.
    + red. red. eexists. red. red.
      intros [[? ?] ?] h. inversion h.
  - apply on_header.
  Unshelve. constructor.
  + intro. exact (BinNums.xH).
  + intro. auto.
Qed.

Lemma confluenv_Σheader :
  confluenv Σheader.
Proof.
  constructor.
  - constructor.
  - constructor.
Qed.

(**
Instance tHead : term :=
| hProd
| hSort (u : Universe.t)
| hInd (ind : inductive).
*)

Definition tHead :=
  tInd {|
    inductive_mind := (headerpath, "header") ;
    inductive_ind := 0
  |} Instance.empty.

Definition thProd :=
  tConstruct {|
    inductive_mind := (headerpath, "header") ;
    inductive_ind := 0
  |} 0 Instance.empty.

Definition thSort :=
  tConstruct {|
    inductive_mind := (headerpath, "header") ;
    inductive_ind := 0
  |} 1 Instance.empty.

Definition thInd :=
  tConstruct {|
    inductive_mind := (headerpath, "header") ;
    inductive_ind := 0
  |} 2 Instance.empty.

(** hhead
hhead : term -> header
------------------------
x : name, A B : term ⊢ hhead (tProd x A B) ↦ hProd
i : Universe.t ⊢ hhead (tSort i) ↦ hSort i
ind : inductive, ui : Instance.t ⊢ hhead (tInd ind ui) ↦ hInd ind
 *)

Definition hhead_path := MPfile [ "hhead" ].

Definition tArrow A B :=
  tProd nAnon A (lift0 1 B).

Definition hhead_decl :=
  RewriteDecl {|
    symbols := [ tArrow tHead ] ;
    rules := [
      {|
        pat_context := [] ,, vass (nNamed "A") t ,, vass (nNamed "m") tNat ;
        head := 0 ;
        elims := [ eApp (tS (tRel 1)) ; eApp (tRel 0) ] ;
        rhs := tS (mkApps (tRel 2) [ tRel 1 ; tRel 0 ])
      |} ;
      {|
        pat_context := [] ,, vass (nNamed "n") tNat ,, vass (nNamed "m") tNat ;
        head := 0 ;
        elims := [ eApp (tRel 1) ; eApp (tS (tRel 0)) ] ;
        rhs := tS (mkApps (tRel 2) [ tRel 1 ; tRel 0 ])
      |} ;
      {|
        pat_context := [] ,, vass (nNamed "m") tNat ;
        head := 0 ;
        elims := [ eApp t0 ; eApp (tRel 0) ] ;
        rhs := tRel 0
      |} ;
      {|
        pat_context := [] ,, vass (nNamed "n") tNat ;
        head := 0 ;
        elims := [ eApp (tRel 0) ; eApp t0 ] ;
        rhs := tRel 0
      |}
    ] ;
    prules := [
      {|
        pat_context := [] ,, vass (nNamed "n") tNat ,, vass (nNamed "m") tNat ;
        head := 0 ;
        elims := [ eApp (tS (tRel 1)) ; eApp (tS (tRel 0)) ] ;
        rhs := tS (tS (mkApps (tRel 2) [ tRel 1 ; tRel 0 ]))
      |}
    ] ;
    rew_universes := nouniv
  |}.

Definition Σpplus := ((pplus_path, "pplus"), pplus_decl) :: Σnat.
