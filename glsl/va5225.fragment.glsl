#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float pack(vec3 color)  { return color.r + color.g * 256. + color.b * 256. * 256.; }

vec3 unpack(float f)  {
    float b = floor(f / (256. * 256.));
    float g = floor((f - b * 256. * 256.) / 256.);
    float r = floor(mod(f ,256.));
    return vec3(r, g, b);
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy/(resolution/3.));

	float ffx = p.x;
	float ffy = p.y;
	float cool = mod( time/10. , p.y-sin(p.x));
	float cool2 = mod( time/10. , p.x-sin(p.y));
	vec3 color = vec3(cool,cool2,1.);
	
	gl_FragColor = vec4( color , 1.0 );

}