sigma.parsers.json('../../data/eth-coop.json', {
    container: 'container',
    settings: {
        scalingMode: "outside",
        drawLabels: true,
        defaultLabelSize: 10,
        labelThreshold: 5,
        maxNodeSize: 4
    }
});
