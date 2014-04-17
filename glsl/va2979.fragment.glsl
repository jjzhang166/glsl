// @rotwang: colorful spiral using radial hue

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

vec3 hsv2rgb(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}

void main( void ) {
    
	float aspect = resolution.x /resolution.y;
	vec2 unipos = ( gl_FragCoord.xy / resolution );
	//unipos.x *=aspect;
	vec2 bipos = unipos*2.0-1.0;
	bipos.x *=aspect;
    
    float sint = sin(time*0.25);
    float usint = sint*0.5-0.5;	
    float angle = 0.0 ;
    float radius = length(bipos);
    if (bipos.x != 0.0 && bipos.y != 0.0){
        angle = degrees(atan(bipos.x,bipos.y)) ;
    }
    float mm = mod(angle+25.0*time-50.0*log(radius), 20.0);
	
	float hue = radius + usint;
	float lum = length( bipos)*1.5;
	vec3 rgb = hsv2rgb(hue,0.9, 0.9);
	
    if (mm>3.0){
        rgb = vec3( 0.0, 0.0, 0.0 );
    } else{
        rgb = hsv2rgb(hue,0.9, lum);                    
    }
	
	gl_FragColor = vec4(rgb, 1.0);
}
