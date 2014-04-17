#ifdef GL_ES
precision mediump float; 
#endif

uniform vec2 resolution;
uniform float time;

const float Pi = 3.14159;

float sinApprox(float x) {
    x = Pi + (2.0 * Pi) * floor(x / (2.0 * Pi)) - x;
    return (4.0 / Pi) * x - (4.0 / Pi / Pi) * x * abs(x);
}

float cosApprox(float x) { 
    return sinApprox(x + 0.5 * Pi);
}

void main()
{
	vec2 p=(2.0*gl_FragCoord.xy-resolution)/max(resolution.x,resolution.y);
	for(int i=1;i<50;i++)
	{
		vec2 newp=p;
		newp.x+=0.3/float(i)*sin(float(i)*p.y+time+0.3*float(i));
		newp.y+=0.3/float(i)*sin(float(i)*p.x+time+0.3*float(i+10));
		p=newp;
	}
	vec3 col=vec3(p.x-floor(p.x),p.y-floor(p.y),p.x*p.y*10.0);
	gl_FragColor=vec4(col, 1.0);
}
