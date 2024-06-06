local Class = require(script.Parent.Parent:WaitForChild("main"))
local def = Class.func
local event = Class.event
local get = Class.getProp
local set = Class.setProp
local super = Class.setProps
local null = Class.null

--[[

class Country:
    """Super Class"""

    name = '국가명'
    population = '인구'
    capital = '수도'

    def show(self):
        print('국가 클래스의 메소드입니다.')


class Korea(Country):
    """Sub Class"""

    def __init__(self, name,population, capital):
        self.name = name
        self.population = population
        self.capital = capital

    def show(self):
        print(
            """
            국가의 이름은 {} 입니다.
            국가의 인구는 {} 입니다.
            국가의 수도는 {} 입니다.
            """.format(self.name, self.population, self.capital)
        )
    ... 생략

]]

local Country = {}
Country = Class "Country" {
	name = "국가명";
	population = "인구";
	capital = "수도";

	def ":show" (function()
		print("국가 클래스의 메소드입니다.")
	end)
}

Country.childClassCreated:Connect(print, "Created new child class:")

local Korea = {}
Korea = Country "Korea" {
	def "__init" (function(self, _, name, population, capital)
		super(self) {
			name = name;
			population = population;
			capital = capital;
		}
	end);

	def ":show" (function(self)
		print(([[국가의 이름은 %s 입니다.
			국가의 인구는 %s 입니다.
			국가의 수도는 %s 입니다.]]):format(self.name, self.population, self.capital))
	end)
}

local a = Country.new()
a:show()

local b = Korea.new("대한민국", 50000000, "서울")
b:show()

return nil