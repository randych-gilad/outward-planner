defmodule OutwardPlannerWeb.Page do
  use OutwardPlannerWeb, :live_view
  import Ecto.Query, except: [update: 3]
  alias OutwardPlanner.Repo
  alias OutwardPlanner.Stats

  def render(assigns) do
    ~H"""
    <label for="weapons-dropdown">Choose a weapon:</label>
    <select id="weapons-dropdown" name="weapons-dropdown">
      <%= for weapon <- @weapons do %>
        <option value="{@weapon}"><%= weapon %></option>
      <% end %>
    </select><br>

    <label for="offhands-dropdown">Choose an off-hand weapon:</label>
    <select id="offhands-dropdown" name="offhands-dropdown">
      <%= for offhand <- @offhands do %>
        <option value="{@offhand}"><%= offhand %></option>
      <% end %>
    </select><br>

    <label for="armors-dropdown">Choose an armor:</label>
    <select id="armors-dropdown" name="armors-dropdown">
      <%= for armor <- @armors do %>
        <option value="{@armor}"><%= armor %></option>
      <% end %>
    </select><br>

    <label for="skills-dropdown">Choose a skill:</label>
    <select id="skills-dropdown" name="skills-dropdown">
      <%= for skill <- @skills do %>
        <option value="{@skill}"><%= skill %></option>
      <% end %>
    </select>
    """
  end

  def mount(_params, _session, socket) do
    weapons =
      Repo.all(
        from w in Stats.Weapon,
          where: w.class not in ["Offhand", "Lexicon", "Lantern"],
          select: w.name
      )

    offhands =
      Repo.all(
        from w in Stats.Weapon,
          where: w.class in ["Offhand", "Lexicon", "Lantern"],
          select: w.name
      )

    armors = Repo.all(from a in Stats.Armor, select: a.name)
    skills = Repo.all(from s in Stats.Skill, select: s.name)

    {:ok, assign(socket, weapons: weapons, offhands: offhands, armors: armors, skills: skills)}
  end
end
