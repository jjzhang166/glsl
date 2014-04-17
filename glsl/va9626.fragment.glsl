#ifdef GL_ES
  precision highp float;
#endif

//
// Global variable definitions
//

uniform sampler2D multiply_mask;
uniform sampler2D screen;
uniform sampler2D screen_mask;

//
// Function declarations
//

vec4 xlat_main( in vec2 uv );

//
// Function definitions
//

vec4 xlat_main( in vec2 uv ) {
    vec4 sc_color;
    vec4 color;

    sc_color = ((1.00000 - texture2D( screen, uv)) * (1.00000 - texture2D( screen_mask, uv)));
    sc_color = (1.00000 - sc_color);
    color = (sc_color * texture2D( multiply_mask, uv));
    return vec4( color.xyz , 1.00000);
}


//
// Translator's entry point
//
void main() {
	vec4 VaryingTexCoord0; 
    vec4 xlat_retVal;

    xlat_retVal = xlat_main( vec2(VaryingTexCoord0));
  
}
