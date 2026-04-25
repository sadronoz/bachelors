shader_type canvas_item;

uniform vec4 color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform float multiplier : hint_range(0.0, 1.0) = 0.1;      
uniform float softness : hint_range(0.0, 5.0) = 0.8;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Vypočítáme vzdálenost od středu (0.5, 0.5)
    float distance_to_center = distance(UV, vec2(0.5));
    
    // Vytvoříme masku okraje pomocí smoothstep
    float mask = smoothstep(multiplier, softness, distance_to_center);
    
    // Nastavíme barvu pixelu s vypočítanou průhledností
    COLOR = vec4(color.rgb, mask);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
