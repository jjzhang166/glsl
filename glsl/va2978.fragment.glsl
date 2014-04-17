// @rotwang: testing smoothrect


#ifdef GL_ES
precision mediump float;
#endif


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


vec3 hsv2rgb(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}


float smoothrect( float f)
{
    float r = sign(sin( f));
    float s = sin( f);
    
    return mix(r,s, 1.0 - abs(s));
}

void main( void ) {

	float aspect = resolution.x /resolution.y;
	vec2 unipos = ( gl_FragCoord.xy / resolution.xy );
	unipos.x *=aspect;

	float sint = sin(time);
	float cost = cos(time);
	float size = 32.0;
	
	float a = sint * smoothrect(  unipos.x *size);
	float b = cost * smoothrect(  unipos.y *size );
	float shade = mix(a,b, pow(sint*4.0,cost));
	shade = clamp(shade,0.0,0.45);
	shade *= unipos.x*2.0;
	
	gl_FragColor = vec4(hsv2rgb(shade, 0.86, shade*2.0), 1.0); 

}
