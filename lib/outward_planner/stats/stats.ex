defmodule OutwardPlanner.Stats.Damage do
  defstruct physical: 0, ethereal: 0, fire: 0, frost: 0, lightning: 0, decay: 0
end

defmodule OutwardPlanner.Stats.Bonus do
  defstruct physical: 0,
            ethereal: 0,
            fire: 0,
            frost: 0,
            lightning: 0,
            decay: 0,
            manacost_reduction: 0
end

defmodule OutwardPlanner.Stats.Weapon do
  defstruct name: "",
            class: "",
            type: "",
            damage: %OutwardPlanner.Stats.Damage{},
            impact: 0,
            impact_resistance: 0,
            attack_speed: 0,
            stamina_cost: 0,
            effects: "",
            bonus: %OutwardPlanner.Stats.Bonus{},
            protection: 0,
            set: ""
end
