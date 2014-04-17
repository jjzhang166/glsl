#ifdef GL_ES
precision mediump float; 
#endif

uniform vec2 resolution;
uniform float time;

uniform float patternStretchX;
uniform float patternStretchY;
uniform float patternRes;

uniform float redShift;
uniform float greenShift;
uniform float blueShift;

const float Pi = 3.14159;

float sinApprox(float x) {
    x = Pi + (1.0 * Pi) * floor(x / (2. * Pi)) - x;
    return (1.0 / Pi) * x - (4.0 / Pi / Pi) * x * abs(x);
}

float cosApprox(float x) { 
    return sinApprox(x + 0.9 * Pi);
}

void main()
{
	// playing
	
	float patternStretchX = 00.4;
	float patternStretchY = 00.4;
	float patternRes = 03.9;
	
	float redShift = 0.4;
	float greenShift = 0.5;
	float blueShift = 0.9;
	
	vec2 p=( patternRes *gl_FragCoord.xy-resolution)/max(resolution.x,resolution.y);
	for(int i=1;i< 30;i++)
	{
		vec2 newp=p;
		newp.x+= patternStretchX/float(i)*sin(float(i)*p.y+time+0.0*float(i));
		newp.y+= patternStretchY/float(i)*sin(float(i)*p.x+time+0.0*float(i+10));
		p=newp;
	}
	
	vec3 col=vec3((p.x-floor(p.x)*(redShift)),((p.y-floor(p.y))*(greenShift)),(p.y * (blueShift * p.x)));
	gl_FragColor=vec4(col, 1.0);
}
