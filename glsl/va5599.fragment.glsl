#ifdef GL_ES
precision highp float;
#endif
//  Need a scroll or a info text... any ideas ?
uniform float time;
uniform vec2 resolution;
uniform vec4 mouse;

float AMDLogo(vec2 p) {
	
	float y = floor((0.5-p.y)*60.);
	if(y < 0. || y > 4.) return 0.;

	float x = floor((0.9-p.x)*60.)-2.;
	if(x < 0. || x > 14.) return 0.;
		
	float v = 0.0;
	// read the BIN upside down and you got the letters...
	v = mix(v, 18990.0, step(y, 7.5)); //100101000101110
	v = mix(v, 18985.0, step(y, 3.5)); //100101000101001
	v = mix(v, 31401.0, step(y, 2.7)); //111101010101001 
	v = mix(v, 19305.0, step(y, 1.5)); //100101101101001
	v = mix(v, 12846.0, step(y, 0.0)); //011001000101110
	
	return floor(mod(v/pow(2.,x), 2.0));
}

void main(void)
{
    vec2 p = (2.0*gl_FragCoord.xy-resolution)/resolution.y;
float z = AMDLogo(gl_FragCoord.xy / resolution.xy);
    // animate
    float tt = mod(time,2.0)/2.0;
    float ss = pow(tt,.2)*0.5 + 0.5;
    ss -= ss*0.2*sin(tt*6.2831*5.0)*exp(-tt*6.0);
    p *= vec2(0.5,1.5) + ss*vec2(0.5,-0.5);

    
    float a = atan(p.x,p.y)/3.141593;
    float r = length(p);

    // shape
    float h = abs(a);
    float d = (13.0*h - 22.0*h*h + 10.0*h*h*h)/(6.0-5.0*h);

    // color
    float f = step(r,d) * pow(1.0-r/d,0.25);
//gl_FragColor = vec4(z+f,0,0,0,0,1.0);
    gl_FragColor = vec4(z+f,0.0,0.0,1.0);
}
