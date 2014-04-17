//fractal: Apollonian Gasket

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform sampler2D texture;
//uniform vec2 mouse;
uniform float time;
varying vec2 surfacePosition;

vec2 mult(vec2 a, vec2 b) { // complex prod a*b
	return vec2(a.x*b.x-a.y*b.y, a.x*b.y+a.y*b.x);
}

vec2 div(vec2 a, vec2 b) { //complex div a/b
	return 1./(b.x*b.x+b.y*b.y)*mult(a,vec2(b.x,-b.y));
}

vec2 moeb(vec2 a, vec2 b, vec2 c, vec2 d, vec2 z) { //complex moebius transformation
	return div(mult(a,z)+b,mult(c,z)+d);
}

vec2 csqrt(vec2 z) { //complex square root
	float a = atan(z.y,z.x)/2.;
	float r = sqrt(length(z));
	return vec2(sqrt(r)*vec2(cos(a),sin(a)));
}

vec2 a[4];
vec2 b[4];
vec2 c[4];
vec2 d[4];


void main() {
	//return;
	a[0] = vec2(1,0);
	b[0] = vec2(0,0);
	c[0] = vec2(0,-2);
	d[0] = vec2(1,0);
	
	a[1] = vec2(1,-1);
	b[1] = vec2(1,0);
	c[1] = vec2(1,0);
	d[1] = vec2(1,1);
	
	a[2] = d[0];
	b[2] = -b[0];
	c[2] = -c[0];
	d[2] = a[0];
	
	a[3] = d[1];
	b[3] = -b[1];
	c[3] = -c[1];
	d[3] = a[1];
	
	/*
	vec2 ta = vec2(2,0);
	vec2 tb = vec2(2,0);
	
	vec2 ta2 = mult(ta,ta);
	vec2 tb2 = mult(tb,tb);
	//vec2 tab = 0.5*(mult(ta,tb)+csqrt(mult(ta2,tb2)-4.*(ta2+tb2)));
	vec2 tab = vec2(2,2);
	//vec2 tab = mouse;
	
	 /// joergensens rezept ///
	a[2] = d[0];
	b[2] = -b[0];
	c[2] = -c[0];
	d[2] = a[0];
	
	a[3] = d[1];
	b[3] = -b[1];
	c[3] = -c[1];
	d[3] = a[1];
	*/
	float ratio = resolution.y/resolution.x;
	vec2 z = surfacePosition * 2.75;
	
	vec4 color;
	color = vec4(0,0,0,1);
	
	for(int i=0; i<4; i++)
		if(length(z)<1.1)
		if(i!=0 || length(vec2(0,-0.25)-z)<.247)
		if(i!=1 || length(vec2(-1,-1)-z)<.997)	
		if(i!=2 || z.y > 0.)
		if(i!=3 || length(vec2(1,-1)-z)<.997)
		{
			vec2 res = moeb(a[i],b[i],c[i],d[i],z);
			//vec2 res = div(mult(z,mult(z,z)),z)-mouse-vec2(0.5,0.5);
			
			float l = length(res);
			res /= 3.0;
			vec2 tar = res;
			tar.y /= ratio;
			tar += vec2(0.5,0.5);
			if(0. < tar.x && tar.x < 1. && 0. < tar.y && tar.y < 1.){ //onscreen?
				color = texture2D( texture, tar );
				color += (vec4(.2*float(i==0 || i==3),.1*float(i==1 || i==3),.2*float(i==0),1)+vec4(.05))*exp(-l);
			}
			
			
			
	}
	gl_FragColor = color;
	//gl_FragColor += 0.1*vec4(.05,.05,.05,1);
	gl_FragColor.a = 1.;
}