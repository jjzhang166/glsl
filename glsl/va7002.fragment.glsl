varying highp vec2 surfacePosition;
uniform highp float time;
highp float radius = 0.1;

void main()
{

    gl_FragColor = vec4(tan(cos(surfacePosition.x) / radius), tan(sin(surfacePosition.y) / radius), sin(tan(surfacePosition.x * surfacePosition.y) / radius), 1.0) * sin(time);
}
