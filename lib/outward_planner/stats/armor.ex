defmodule OutwardPlanner.Stats.Armor do
  @moduledoc """
  Armor struct.

  Elements without bonus refer to resistance.

  Elements with bonus refer to % damage increase.
  """
  defstruct name: "",
            class: "",
            type: "",
            set: "",
            protection: 0,
            barrier: 0,
            mana_cost_reduction: 0,
            stamina_cost_reduction: 0,
            movespeed: 0,
            cooldown: 0,
            effects: "",
            pouch: 0,
            decay: 0,
            decay_bonus: 0,
            ethereal: 0,
            ethereal_bonus: 0,
            fire: 0,
            fire_bonus: 0,
            frost: 0,
            frost_bonus: 0,
            impact: 0,
            lightning: 0,
            lightning_bonus: 0,
            physical: 0,
            physical_bonus: 0,
            coldresist: 0,
            heatresist: 0,
            corruptresist: 0,
            status_resist: 0
end
