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

	vec2 p = ( gl_FragCoord.xy/resolution);

	vec3 color = unpack(p.x*16777215.)/255.;
	
	gl_FragColor = vec4( color , 1.0 );

}