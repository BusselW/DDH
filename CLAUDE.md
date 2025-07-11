# DDH Portal Project - Claude Instructions

## Project Overview
DDH (Digitale Handhaving) is a Dutch enforcement monitoring portal system that displays handhavingsdata (enforcement data) from SharePoint. The project consists of multiple portal designs with layered navigation for exploring enforcement locations and problems.

## Architecture
- **Frontend**: Pure JavaScript with React (via CDN)
- **Data Source**: SharePoint REST API through DDH_CONFIG
- **Icons**: Custom SVG icon library (`js/components/svgIcons.js`)
- **Styling**: CSS with modern gradients and responsive design

## Navigation Pattern
All portals implement a 3-layer navigation flow:
1. **Gemeente Layer**: Select municipality (gemeente)
2. **Pleeglocatie Layer**: Select enforcement location (pleeglocatie) 
3. **Detail Layer**: View complete information with problem filtering

## Key Data Structure
```javascript
// Location object from SharePoint
{
  Id: "unique-id",
  Title: "Location name",
  Gemeente: "Municipality name", 
  Status_x0020_B_x0026_S: "B&S Status",
  Feitcodegroep: "Fact code group",
  problemen: [
    {
      Id: "problem-id",
      Probleembeschrijving: "Problem description",
      Opgelost_x003f_: "Opgelost" | "Aangemeld" | "In behandeling" | "Uitgezet",
      Aanmaakdatum: "2024-01-01T00:00:00Z",
      Feitcodegroep: "Category"
    }
  ]
}
```

## Portal Designs
1. **Portal-Design1-Grid.aspx**: Basic grid layout
2. **Portal-Design2-Cards.aspx**: Card-based design  
3. **Portal-Design3-Map.aspx**: Geographic/map style (dark theme)
4. **Portal-Design4-Timeline.aspx**: Timeline with layered navigation
5. **Portal-Design5-Dashboard.aspx**: Executive dashboard with layered navigation
6. **Portal-Design6-Layered.aspx**: Primary layered navigation example
7. **Portal-Design7-Modern.aspx**: Modern card design with animations

## Required Features
- **Problem Filtering**: All/Active (not "Opgelost")/Resolved ("Opgelost")
- **Document Links**: Schouwrapporten and Algemeen PV links
- **Contact Information**: Display gemeente, status, and feitcodegroep
- **Breadcrumb Navigation**: Home > Gemeente > Pleeglocatie
- **SVG Icons**: Use icons from `js/components/svgIcons.js`
- **Responsive Design**: Mobile-friendly layouts

## Component Structure
```javascript
// Standard React functional component pattern
const PortalComponent = () => {
  const [currentLayer, setCurrentLayer] = useState('gemeente');
  const [selectedGemeente, setSelectedGemeente] = useState(null);
  const [selectedPleeglocatie, setSelectedPleeglocatie] = useState(null);
  const [problemFilter, setProblemFilter] = useState('all');
  
  // Import SVG icons
  const { HomeIcon, BuildingIcon, CheckIcon, WarningIcon } = SvgIcons;
  
  return h('div', null, /* JSX-like structure */);
};
```

## Coding Standards
- Use `createElement` as `h` for React elements
- Import SVG icons from `js/components/svgIcons.js`
- Never use UTF-8 emoji characters - always use SVG icons
- Follow Dutch terminology (gemeente, pleeglocatie, problemen)
- Implement proper error handling and loading states
- Ensure accessibility with proper ARIA labels

## Test Commands
- **Lint**: `npm run lint` (if available)
- **Build**: `npm run build` (if available) 
- **TypeCheck**: `npm run typecheck` (if available)

## Development Notes
- All portal files are `.aspx` for SharePoint compatibility
- Data is loaded via `DDH_CONFIG.queries.haalAllesMetRelaties()`
- Icons must be imported and used as React components
- Problem status filtering is critical for user experience
- Breadcrumb navigation should reset state properly

## Common Issues
- UTF-8 characters don't render properly → Use SVG icons
- Missing navigation flow → Implement 3-layer pattern
- Poor mobile experience → Add responsive CSS
- Missing problem filtering → Add filter buttons with proper state

## File Structure
```
DDH/
├── Portal-Design[1-7]-*.aspx     # Portal implementations
├── js/
│   ├── components/
│   │   └── svgIcons.js           # SVG icon library
│   └── config/
│       └── index.js              # DDH_CONFIG
└── CLAUDE.md                     # This file
```

Always prioritize user experience with smooth navigation, clear visual hierarchy, and consistent design patterns across all portals.