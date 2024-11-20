defmodule OutwardPlanner.Stats.Weapon do
  @moduledoc """
  Weapon struct.

  Elements without bonus refer to flat damage.

  Elements with bonus refer to % damage increase.
  """
  defstruct name: "",
            class: "",
            type: "",
            set: "",
            protection: 0,
            barrier: 0,
            impact_resistance: 0,
            mana_cost_reduction: 0,
            stamcost: 0,
            attackspeed: 0,
            effects: "",
            impact: 0,
            physical: 0,
            physical_bonus: 0,
            decay: 0,
            decay_bonus: 0,
            ethereal_bonus: 0,
            ethereal: 0,
            fire: 0,
            fire_bonus: 0,
            frost: 0,
            frost_bonus: 0,
            lightning: 0,
            lightning_bonus: 0
end
