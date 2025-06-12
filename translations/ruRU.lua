--Translator: ZamestoTV
if (GAME_LOCALE or GetLocale()) ~= "ruRU" then
  return
end

local T = AngleurUnderlight_Translate

local colorUnderlight = CreateColor(0.9, 0.8, 0.5)
local colorYello = CreateColor(1.0, 0.82, 0.0)
local colorBlu = CreateColor(0.61, 0.85, 0.92)
local colorWhite = CreateColor(1, 1, 1)

T["\nset as Main Fishing Rod."] = "\nустановить как основную удочку."

T["\nWhen you start swimming, the " .. colorUnderlight:WrapTextInColorCode("Underlight Angler ") .. " will be " 
.. "equipped to trigger the buff.\n\nWhen you stop swimming, your main fishing rod will be re-equipped"] = "\nКогда вы начнете плавать, " 
.. colorUnderlight:WrapTextInColorCode("Удочка Темносвета ") .. " будет экипирована для активации баффа.\n\nКогда вы перестанете плавать, ваша основная удочка будет переэкипирована."

T["No main fishing rod set"] = "Основная удочка не установлена"

T["\nYour " .. colorUnderlight:WrapTextInColorCode("Underlight Angler ") 
.. "will be swapped in and out to keep the buff active when you start/stop swimming.\n\n" 
.. colorYello:WrapTextInColorCode("Drag ") .. "a fishing rod here to set it as main."] = "\nВаша " 
.. colorUnderlight:WrapTextInColorCode("Удочка Темносвета ") .. "будет переключаться для поддержания активного баффа, когда вы начинаете/прекращаете плавать.\n\n" 
.. colorYello:WrapTextInColorCode("Перетащите ") .. "удочку сюда, чтобы установить её как основную."

T["Can't drag item in combat."] = "Нельзя перетаскивать предмет в бою."
T["Not an equippable item. Please drag in your main fishing rod."] = "Не экипируемый предмет. Пожалуйста, перетащите вашу основную удочку."
T["Not a fishing rod. Please drag in your main fishing rod."] = "Не удочка. Пожалуйста, перетащите вашу основную удочку."
T["Item is equippable and fishing related, but not a fishing rod. Please drag in your main fishing rod."] = "Предмет экипируемый и связан с рыбалкой, но не является удочкой. Пожалуйста, перетащите вашу основную удочку."

T[" the draggable item slot is reserved fishing rods that are NOT the " .. colorUnderlight:WrapTextInColorCode("Underlight Angler. ") 
.. "If you would like to use the Underlight Angler as your \'Main\' fishing rod, " 
.. "you can keep the box empty."] = " слот для перетаскивания предметов зарезервирован для удочек, которые НЕ являются " 
.. colorUnderlight:WrapTextInColorCode("Удочкой Темносвета. ") .. "Если вы хотите использовать Удочку Темносвета как основную удочку, " 
.. "вы можете оставить слот пустым."

T["The main fishing rod not found in bags. Cannot swap."] = "Основная удочка не найдена в сумках. Нельзя переключить."
T[" to open up the configuration if you'd like to change/remove the main fishing rod."] = " чтобы открыть настройки, если вы хотите изменить/удалить основную удочку."
T["Underlight Angler not found in bags. Cannot equip."] = "Удочка Темносвета не найдена в сумках. Нельзя экипировать."

T[colorWhite:WrapTextInColorCode("Get ") .. colorBlu:WrapTextInColorCode("Angleur ") 
.. colorWhite:WrapTextInColorCode("for increased functionality!")] = colorWhite:WrapTextInColorCode("Получите ") .. colorBlu:WrapTextInColorCode("Angleur ") 
.. colorWhite:WrapTextInColorCode("для расширенной функциональности!")

T["to re-open this window."] = "чтобы повторно открыть это окно."
