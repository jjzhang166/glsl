#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


vec3 Hue(float H){
    float r = abs(H * 6. - 3.) - 1.;
    float g = 2. - abs(H * 6. - 2.);
    float b = 2. - abs(H * 6. - 4.);
    return clamp(vec3(r,g,b), vec3(0.,0.,0.), vec3(1.,1.,1.));
}

vec4 HSVtoRGB(vec3 HSV){
    return vec4(((Hue(HSV.x) - 1.) * HSV.y + 1.) * HSV.z, 1.);
}


void main( void ) {
    vec2 p = ( gl_FragCoord.xy );
    float dx = 500.;
    float dy = 250.;
    float a = atan(p.x-dx, p.y-dy)+3.141592;
    float r2 = (p.x-dx)*(p.x-dx)+(p.y-dy)*(p.y-dy);

    int idx = int(mod(p.x*0.1625, 17.0));

    vec3 hsv = vec3(p.x*.02, 1.0, 1.0);

    vec4 cc = HSVtoRGB(vec3(a/6.28,1.,1.));

	// invert for speed
	if(r2<400.) // 20^2
		cc = HSVtoRGB(vec3(mod(time/43200.,1.) ,1.,1.));
    	else if(r2<1600.) // 40^2
        	cc = HSVtoRGB(vec3(mod(time/3600.,1.), 1.,1.));
	else if(r2<3600.) // 60^2
		cc = HSVtoRGB(vec3(mod(time/60.,1.), 1.,1.));
	else if(r2<6400.) // 80^2
		cc = HSVtoRGB(vec3(mod(time,1.), 1.,1.));

    gl_FragColor = cc;

} 