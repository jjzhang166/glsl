#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// a liitle bit modified shader from http://pouet.net/prod.php?which=59610
//
// fixed http://glsl.heroku.com/e#3521.2 to work on windows as well

vec3 s,p;
float v,m,g=1.,e=0.,d=mod(time+10.,150.)*.1;
float t(vec3 g) {
	m=1.;
	p=g;
        for (int r=0;r<20;r++)
	{
	    p-=2.*min(max(p,-1.),1.);
            v=2./min(max(dot(p,p),.25),1.);
	    m=v*m+1.;
	    p=g-v*p;
	}
        return(sqrt(dot(p,p))-1.)/m;
}

void main() {
	vec3 o=normalize(vec3(gl_FragCoord.xy/resolution.y,.7)-vec3(.9,.5,0.));

	float n=.1;
	for (int u=0;u<1000;u++)
	{
		e+=.01;
                g=t(s=o*n+(d<4.?vec3(d-7.,-2.9,5.3):d<8.?vec3(-5.3,-5.3,d-10.):
                vec3(4.3,4.9,d-8.)));
		if (n>9. || g<.001) break;
		n+=g;
	}
        gl_FragColor=vec4(1.,.3,0.,0.)*
		(pow(max(dot(reflect(vec3(0.,0.,1.),normalize(vec3(t(s+vec3(.001,0.,0.))-g,
		t(s+vec3(0.,.001,0.))-g,5e-05))),o),0.),50.)+e);
}

