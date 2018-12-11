
--# assume global class COMPONENTS
local Components = {}; --# assume Components: COMPONENTS

--v function(component: CA_UIC, width: number, height: number)
function Components.resize(component, width, height)
    component:Resize(width, height);
end

--v function(component: CA_UIC, factor: number)
function Components.scale(component, factor)
    --# assume component: CA_UIC
    local width, height = component:Bounds();
    Components.resize(component, width * factor, height * factor);
end

--v function(component: CA_UIC, xMove: number, yMove: number)
function Components.move(component, xMove, yMove)
    --# assume component: CA_UIC
    local curX, curY = component:Position();
    component:MoveTo(curX + xMove, curY + yMove);
end

--v function(componentToMove: CA_UIC , relativeComponent: CA_UIC, xDiff: number, yDiff: number)    
function Components.positionRelativeToUiComponent(componentToMove, relativeComponent, xDiff, yDiff)
    local uic = relativeComponent;
    local relX, relY = uic:Position();
    componentToMove:MoveTo(relX + xDiff, relY + yDiff);
end


--v function(component: CA_UIC, disabled: boolean)
function Components.disableComponent(component, disabled)
    component:SetDisabled(disabled);
    if disabled then
        component:SetOpacity(50);
    else
        component:SetOpacity(100);
    end
end

return {
    scale = Components.scale;
    move = Components.move;
    positionRelativeTo = Components.positionRelativeToUiComponent;
    resize = Components.resize;
    disableComponent = Components.disableComponent;
}