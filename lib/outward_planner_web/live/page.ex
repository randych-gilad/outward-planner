defmodule OutwardPlannerWeb.Page do
  use OutwardPlannerWeb, :live_view
  import Ecto.Query, except: [update: 3]
  alias OutwardPlanner.Repo

  def render(assigns) do
    ~H"""
    <label for="weapons-dropdown">Choose a weapon:</label>
    <select id="weapons-dropdown" name="weapons-dropdown">
      <%= for weapon <- @weapons do %>
        <option value="{@weapon}"><%= weapon %></option>
      <% end %>
    </select>

    <label for="armors-dropdown">Choose an armor:</label>
    <select id="armors-dropdown" name="armors-dropdown">
      <%= for armor <- @armors do %>
        <option value="{@armor}"><%= armor %></option>
      <% end %>
    </select>

    <label for="skills-dropdown">Choose a spell:</label>
    <select id="skills-dropdown" name="spells-dropdown">
      <%= for skill <- @skills do %>
        <option value="{@skill}"><%= skill %></option>
      <% end %>
    </select>
    """
  end

  def mount(_params, _session, socket) do
    weapons = Repo.all(from w in OutwardPlanner.Stats.Weapon, select: w.name)
    armors = Repo.all(from a in OutwardPlanner.Stats.Armor, select: a.name)
    skills = Repo.all(from s in OutwardPlanner.Stats.Skill, select: s.name)

    {:ok, assign(socket, weapons: weapons, armors: armors, skills: skills)}
  end
end
