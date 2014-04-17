#ifdef GL_ES
precision mediump float;
#endif

#define VerticalBeamDistance 80.
#define BeamWidth 20.
#define xStepsPerBeam 27.
uniform float time;

void main( void )
{
	float CurrentBeamIndex = floor((gl_FragCoord.x + (VerticalBeamDistance / 2.)) / VerticalBeamDistance);
	float CurrentVerticalBeamX = CurrentBeamIndex * VerticalBeamDistance;
	float dist = distance(CurrentVerticalBeamX, gl_FragCoord.x);
	float intensity = clamp((BeamWidth - dist) / BeamWidth, 0.,1.);
	
	
	CurrentBeamIndex = floor(gl_FragCoord.x / VerticalBeamDistance)+1.;
	float functionX = CurrentBeamIndex*xStepsPerBeam;
	float effectiveY = sqrt(mod(pow(functionX,2.),40.))*50.+70.;
	effectiveY += sin(CurrentBeamIndex+time*1.7)*70.;
	dist = distance(effectiveY, gl_FragCoord.y);
	intensity = max(intensity, clamp((BeamWidth - dist) / BeamWidth, 0.,1.));
	
	vec3 color = vec3(1.0,1.0,0.5);
	gl_FragColor = vec4(color * intensity, 1.0);
}